#!/usr/bin/env bash
# Dotfiles sync for every device (Fedora PC, laptop, macOS). Run by topgrade, the user timer, or `backup`.
#  1. write this device's package lists to hosts/<hostname>/
#  2. take local changes into the repo (chezmoi re-add) and commit them
#  3. get the other devices' changes (git pull --rebase) and apply them here (chezmoi apply)
#  4. push; then copy the source into the homelab repo if it exists on this device
set -euo pipefail
S="$(chezmoi source-path)"
HOST="$(chezmoi execute-template '{{ .chezmoi.hostname }}')"
L="$S/hosts/$HOST"; mkdir -p "$L"
cd "$S"

# 1. Package lists (only what exists on this device)
have(){ command -v "$1" >/dev/null 2>&1; }
have dnf      && { dnf repoquery --userinstalled --queryformat '%{name}\n' 2>/dev/null | sort -u > "$L/pkglist.txt" || true; }
have flatpak  && { flatpak list --app --columns=application 2>/dev/null | sort > "$L/flatpaks.txt" || true; }
for b in /home/linuxbrew/.linuxbrew/bin/brew /opt/homebrew/bin/brew; do
  [ -x "$b" ] && { "$b" bundle dump --file="$L/Brewfile" --force >/dev/null 2>&1 || true; break; }
done
have ollama   && { ollama list 2>/dev/null | awk 'NR>1 {print $1}' > "$L/ollama-models.txt" || true; }
have distrobox && { distrobox list --no-color 2>/dev/null | awk -F'|' 'NR>1 {gsub(/ /,"",$2); gsub(/ /,"",$4); printf "[%s]\nimage=%s\n\n", $2, $4}' > "$L/distrobox.ini" || true; }

# 2. Local changes into the repo
chezmoi re-add
git add -A
git diff --cached --quiet || git commit -q -m "Auto backup from $HOST: $(date -Iseconds)"

# 3. Changes from the other devices
if ! git pull -q --rebase; then
  git rebase --abort 2>/dev/null || true
  echo "cz-sync: merge conflict with another device. Nothing pushed. Fix by hand in $S (git status)." >&2
  exit 1
fi
chezmoi apply --force

# 4. Push
if [ -n "$(git log '@{u}..' --oneline 2>/dev/null)" ]; then git push -q && echo "dotfiles pushed ($HOST)"; else echo "dotfiles up to date ($HOST)"; fi

if [ -x "$HOME/homelab-repo/tools/pc-config.sh" ]; then
  "$HOME/homelab-repo/tools/pc-config.sh" || echo "pc-config.sh failed (homelab repo not reachable?)"
fi
