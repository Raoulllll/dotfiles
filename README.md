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

🚀 Quick Start & Deployment
1. Initialize and Apply
If you already have Chezmoi installed on a fresh system, bootstrap everything with a single command:

Bash
chezmoi init --apply Raoulllll
2. Manual Setup Sequence
Alternatively, you can clone down your source and run your local bootstrap execution pipeline directly:

Bash
# Initialize source path
chezmoi init Raoulllll

# Run your custom configuration script 
cd ~/.local/share/chezmoi
./executable_bootstrap.sh
🔧 Maintenance Utilities
Your configuration provides specific helper workflows mapped directly in your local binary path:

executable_rebuild: Run this command locally to apply system generation rebuilds quickly.

executable_cz-sync.sh: Handles tracking, staging, and updating configuration definitions safely with Git.

## 🎨 Modern Tools Configured

* **Terminal:** `ghostty`
* **Prompt:** `starship`
* **Navigation & Search:** `zoxide`, `fzf`
* **File Listing:** `eza` (aliased to `ls`)
* **Cat Alternative:** `bat`
