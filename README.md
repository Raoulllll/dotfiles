# Dotfiles (main-pc, laptop, Mac Studio)

Dotfiles and setup scripts for all my devices, managed with [chezmoi](https://www.chezmoi.io/): the Fedora KDE desktop (main-pc, hostname `LinuxV6`), the Fedora laptop and the Mac Studio (macOS, zsh).
Documentation lives in the homelab wiki (`wiki/02 Hardware/main-pc.md`).

## Layout

| Path | What it is |
|---|---|
| `dot_config/` | `~/.config`: kitty, ghostty, fish, micro, starship, fastfetch, gtk, Kvantum, KDE (kwin, plasma), topgrade |
| `dot_config/` (more) | zed, btop, fish plugin list (`fish_plugins`, fisher reinstalls the plugins), KDE shortcuts/colours/power, autostart entries, Hyprland + Caelestia (being tried), systemd user timers, `environment.d` (SSH agent socket) |
| `dot_local/bin/` | helper scripts, e.g. `cz-sync.sh` (lists, re-add, commit, push), `fetch-layout`, `steam-gamescope-wrapper` |
| `dot_gitconfig` | `~/.gitconfig` |
| `fedorabootstrap.sh` | Fedora setup: RPM Fusion, Copr repos, core packages |
| `hosts/<hostname>/` | per-device lists written by `cz-sync.sh`: `pkglist.txt` (dnf), `flatpaks.txt`, `Brewfile`, `distrobox.ini`, `ollama-models.txt`; never applied to `$HOME` |
| `dot_zshrc` | macOS only |
| `executable_bootstrap.sh` | first-time setup on a new PC (GitHub login over ssh, then `chezmoi init --apply`) |
| `run_once_before_setup.sh` | runs once on the first `chezmoi apply`: GitHub login, git credential helper |
| `archive/` | old NixOS config and a model download note; ignored by chezmoi (`.chezmoiignore`) |

chezmoi file names use prefixes: `dot_` = leading dot, `private_` = restricted permissions, `executable_` = executable.

## Use

```
chezmoi init --apply Raoulllll
```

Changes: edit the file in `$HOME`, then `chezmoi re-add` (or run `cz-sync.sh`), which commits and pushes.

## Which file goes where

`.chezmoiignore` decides it per device:
- **Everywhere:** git, starship, fastfetch, kitty, ghostty, micro, btop, htop, zed, topgrade, fish (works without eza, brew or the Steam wrapper), `cz-sync.sh`, `fetch-layout`
- **Linux only:** KDE/Plasma, GTK, Kvantum, Hyprland, Caelestia, PipeWire/WirePlumber, systemd user units, `environment.d`, the other scripts in `~/.local/bin`
- **main-pc only:** monitor layout (`kwinoutputconfig.json`), LACT (GPU), OpenRGB, autostart apps, `steam-gamescope-wrapper` (3440x1440 @ 175 Hz)
- **macOS only:** `.zshrc`

## Keeping devices in sync

`~/.local/bin/cz-sync.sh` runs from topgrade ("System Configuration Backup"), from the daily user timer `cz-sync.timer`, or by hand (`backup` in fish). On every device it:
1. writes the device's package lists to `hosts/<hostname>/`
2. takes local changes into the repo (`chezmoi re-add`) and commits them
3. pulls the other devices' changes (`git pull --rebase`) and applies them (`chezmoi apply`)
4. pushes. On a merge conflict it stops and pushes nothing

## Never tracked (this repo is public)

- `~/.ssh` (keys and host list), passwords, tokens, API keys, `.env` files
- Any script that contains a password or token
- Logs, `*.bak`, caches, app state (browsers, mail, akonadi, baloo, kwallet, recent files)
- Tools installed by pip/uv into `~/.local/bin` (pip, httpx, pytest, …), binaries, AppImages, symlinks
- `~/.local/bin/export_packages.sh` (old Arch/pacman script; replaced by `cz-sync.sh`) and the dwm/X11 scripts (`dwm-*`, `theme-apply.sh`, `xscreensaver-setup.sh`)

## New Fedora PC or laptop

1. Install Fedora (KDE), log in, connect to the network
2. `sudo ./fedorabootstrap.sh` (RPM Fusion, Copr repos, core packages); get it with `curl -O https://raw.githubusercontent.com/Raoulllll/dotfiles/main/fedorabootstrap.sh`
3. `sudo dnf install chezmoi gh`, then `chezmoi init Raoulllll` and **`chezmoi diff`** to see what would change, then `chezmoi apply`
4. Apps from main-pc's lists: `xargs -a ~/.local/share/chezmoi/hosts/LinuxV6/flatpaks.txt flatpak install -y flathub`, `brew bundle --file ~/.local/share/chezmoi/hosts/LinuxV6/Brewfile`, fish plugins: `fisher update`
5. `distrobox assemble create --file ~/.local/share/chezmoi/hosts/LinuxV6/distrobox.ini`; models: `xargs -n1 ollama pull < ~/.local/share/chezmoi/hosts/LinuxV6/ollama-models.txt`
6. Turn on the daily sync: `systemctl --user enable --now cz-sync.timer`

## Mac

1. `brew install chezmoi` (Homebrew is at `/opt/homebrew`)
2. `chezmoi init Raoulllll`, then **`chezmoi diff`**: your current starship, micro, kitty and fish configs would be replaced by the ones in this repo. Keep a copy of anything you want to keep
3. `chezmoi apply`, then run `~/.local/bin/cz-sync.sh` (or add it to topgrade) whenever you want to sync

