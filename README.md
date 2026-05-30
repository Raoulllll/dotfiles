❄️ Dotfiles & NixOS Configuration
A fully declarative, reproducible system configuration and dotfiles management system. This repository combines the power of NixOS Flakes for system-level infrastructure with Chezmoi for flexible, cross-platform user environment personalization.

🛠 Tech Stack
Operating System: NixOS (Declarative system configuration)

Package & Environment Management: Nix Flakes & Home Manager

Dotfiles Manager: Chezmoi (For granular, secure, and template-driven user configurations)

Shell & Core Utilities: Modern, fast, and Rust-based tools (starship, zoxide, eza, bat)

⚙️ Key Features
Hybrid Architecture: NixOS handles the heavy lifting (drivers, system daemons, core packages), while Chezmoi manages specific configuration files, allowing for clean templating and potential cross-distro portability.

AMD Optimized: Fine-tuned for modern AMD hardware (Ryzen Zen 5 3D V-Cache scheduling and open-source amdgpu/Mesa stack).

Modern CLI Toolchain: Replaces legacy GNU utilities with modern, performance-oriented alternatives.

Clean & Modular: Separated system profiles, home environments, and dotfile templates.

📂 Repository Structure
Plaintext
.
├── flake.nix                  # Entry point for the NixOS system configuration
├── hosts/                     # Machine-specific configurations (hardware, hostnames)
├── modules/                   # Reusable NixOS and Home Manager modules
└── dot_local/share/chezmoi/   # Chezmoi source directory (or your preferred chezmoi path)
    ├── dot_config/            # Managed configuration files (ghostty, starship, etc.)
    └── chezmoi.yaml.tmpl      # Chezmoi configuration template
🚀 Quick Start & Deployment
1. Initialize the NixOS System
To bootstrap the system configuration from this flake:

Bash
# Clone the repository
git clone https://github.com/Raoulllll/dotfiles.git ~/zero-dotfiles
cd ~/zero-dotfiles

# Apply the NixOS configuration (replace <hostname> with your specific host)
sudo nixos-rebuild switch --flake .#<hostname>
2. Apply Personal Dotfiles with Chezmoi
Once the core environment and Chezmoi are installed via Nix, initialize your dotfiles:

Bash
# Initialize and apply chezmoi directly from the repository
chezmoi init --apply Raoulllll
For subsequent local changes within the chezmoi source directory:

Bash
chezmoi apply
🎨 Modern Tools Configured
Terminal: kitty

Prompt: starship

Navigation & Search: zoxide, fzf

File Listing: eza (aliased to ls)

Cat Alternative: bat