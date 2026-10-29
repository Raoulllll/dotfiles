# Dotfiles (Fedora, main-pc / LinuxV6)

Dotfiles and setup scripts for the Fedora desktop, managed with [chezmoi](https://www.chezmoi.io/).
Documentation lives in the homelab wiki (`wiki/02 Hardware/main-pc.md`).

## Layout

| Path | What it is |
|---|---|
| `dot_config/` | `~/.config`: kitty, ghostty, fish, micro, starship, fastfetch, gtk, Kvantum, KDE (kwin, plasma), topgrade |
| `dot_local/bin/` | helper scripts, e.g. `cz-sync.sh` (re-add changed files, commit, push) |
| `dot_gitconfig` | `~/.gitconfig` |
| `fedorabootstrap.sh` | Fedora setup: RPM Fusion, Copr repos, core packages |
| `pkglist.txt` | list of installed packages |
| `executable_bootstrap.sh`, `executable_run_once_before_setup.sh` | first-time setup, GitHub login |
| `archive/` | old NixOS config and a model download note; ignored by chezmoi (`.chezmoiignore`) |

chezmoi file names use prefixes: `dot_` = leading dot, `private_` = restricted permissions, `executable_` = executable.

## Use

```
chezmoi init --apply Raoulllll
```

Changes: edit the file in `$HOME`, then `chezmoi re-add` (or run `cz-sync.sh`), which commits and pushes.
