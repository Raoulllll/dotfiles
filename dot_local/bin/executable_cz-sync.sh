#!/bin/bash
# Back up the dotfiles: refresh the generated lists, re-add changed files, commit, push to GitHub,
# then copy the chezmoi source into the homelab repo (documentation copy, tools/pc-config.sh).
# Runs daily from the user timer cz-sync.timer, or by hand with the fish abbreviation `backup`.
set -euo pipefail
S="$(chezmoi source-path)"
cd "$S"

# Generated lists (in the repo, ignored by chezmoi)
dnf repoquery --userinstalled --queryformat '%{name}\n' 2>/dev/null | sort -u > pkglist.txt || true
flatpak list --app --columns=application 2>/dev/null | sort > flatpaks.txt || true
[ -x /home/linuxbrew/.linuxbrew/bin/brew ] && /home/linuxbrew/.linuxbrew/bin/brew bundle dump --file=Brewfile --force >/dev/null 2>&1 || true
command -v ollama >/dev/null && ollama list 2>/dev/null | awk 'NR>1 {print $1}' > ollama-models.txt || true
if command -v distrobox >/dev/null; then
  distrobox list --no-color 2>/dev/null | awk -F'|' 'NR>1 {gsub(/ /,"",$2); gsub(/ /,"",$4); printf "[%s]\nimage=%s\n\n", $2, $4}' > distrobox.ini || true
fi

# Re-add all tracked files that changed in $HOME
chezmoi re-add

if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -q -m "Auto backup: $(date -Iseconds)"
    git push -q
    echo "dotfiles pushed"
else
    echo "No changes to commit."
fi

# Documentation copy into the homelab repo (Forgejo); a failure here must not stop the dotfiles backup
if [ -x "$HOME/homelab-repo/tools/pc-config.sh" ]; then
    "$HOME/homelab-repo/tools/pc-config.sh" || echo "pc-config.sh failed (homelab repo not reachable?)"
fi
