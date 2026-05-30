# ❄️ Dotfiles & NixOS Configuration

A fully declarative, reproducible system configuration and dotfiles management system. This repository combines the power of **NixOS Flakes** for system-level infrastructure with **Chezmoi** for flexible, cross-platform user environment personalization.

## 🛠 Tech Stack

*   **Operating System:** [NixOS](https://nixos.org/) (Declarative system configuration)
*   **Package & Environment Management:** Nix Flakes & [Home Manager](https://github.com/nix-community/home-manager)
*   **Dotfiles Manager:** [Chezmoi](https://www.chezmoi.io/) (For granular, secure, and template-driven user configurations)
*   **Shell & Core Utilities:** Modern, fast, and Rust-based tools (`ghostty`, `starship`, `zoxide`, `eza`, `bat`)

---

## ⚙️ Key Features

*   **Hybrid Architecture:** NixOS handles the heavy lifting (drivers, system daemons, core packages), while Chezmoi manages specific configuration files, allowing for clean templating and potential cross-distro portability.
*   **AMD Optimized:** Fine-tuned for modern AMD hardware (Ryzen Zen 5 3D V-Cache scheduling and open-source `amdgpu`/Mesa stack).
*   **Modern CLI Toolchain:** Replaces legacy GNU utilities with modern, performance-oriented alternatives.
*   **Clean & Modular:** Separated system profiles, home environments, and dotfile templates.

---

## 📂 Repository Structure

```text
chezmoi
├── README.md
├── executable_bootstrap.sh
├── executable_run_once_before_setup.sh
├── dot_gitconfig
├── pkglist.txt
├── bin/
│   ├── executable_autoclicker.py
│   ├── executable_cz-sync.sh
│   ├── executable_fetch-layout
│   └── executable_rebuild
├── dot_local/
└── dot_config/
    ├── Kvantum/
    ├── fastfetch/
    │   ├── config.jsonc
    │   └── my_art.txt
    ├── fish/
    │   └── config.config.fish
    ├── ghostty/
    │   ├── config
    │   ├── empty_config.ghostty
    │   └── themes/
    ├── gtk-3.0/
    ├── gtk-4.0/
    ├── kitty/
    ├── micro/
    │   ├── bindings.json
    │   ├── settings.json
    │   └── plug/filemanager/
    ├── nixos-config/
    │   ├── configuration.nix
    │   └── flake.nix
    ├── private_plasma-org.kde.plasma.desktop-appletsrc
    ├── private_plasmashellrc
    ├── starship.toml
    └── symlink_hypr

```

---

## 🚀 Quick Start & Deployment

### 1. Initialize the NixOS System

To bootstrap the system configuration from this flake:

```bash
# Clone the repository
git clone [https://github.com/Raoulllll/dotfiles.git](https://github.com/Raoulllll/dotfiles.git) ~/zero-dotfiles
cd ~/zero-dotfiles

# Apply the NixOS configuration (replace <hostname> with your specific host)
sudo nixos-rebuild switch --flake .#<hostname>

```

### 2. Apply Personal Dotfiles with Chezmoi

Once the core environment and Chezmoi are installed via Nix, initialize your dotfiles:

```bash
# Initialize and apply chezmoi directly from the repository
chezmoi init --apply Raoulllll

```

For subsequent local changes within the chezmoi source directory:

```bash
chezmoi apply

```

---

## 🎨 Modern Tools Configured

* **Terminal:** `ghostty`
* **Prompt:** `starship`
* **Navigation & Search:** `zoxide`, `fzf`
* **File Listing:** `eza` (aliased to `ls`)
* **Cat Alternative:** `bat`
