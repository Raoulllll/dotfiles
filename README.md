# 󰣇 roehl's Dotfiles

My personal dotfiles managed with `chezmoi`. Optimized for high-end AMD hardware, grand strategy simulation gaming, and a highly efficient, borderless development environment on modern Linux Wayland.

## 💻 System Overview

| Component | Specification |
| :--- | :--- |
| **OS** | CachyOS (Arch-based, optimized x86-64-v4) |
| **DE/WM** | KDE Plasma (Wayland Session) |
| **Terminal** | Kitty (Borderless, Translucent, Blurred) |
| **Shell** | Fish Shell + Starship Prompt |
| **Editor** | Micro (Transparent syntax fallback) |

---

## 🛠️ Key Features & Automated Workflow Configs

### 1. ⚡ Wayland Native Auto-Clicker
Includes a clean Python-based utility (`autoclicker.py`) utilizing `ydotool` to inject raw hardware events directly via the kernel (`/dev/uinput`). Fully integrated into KDE Global Shortcuts for single-hotkey starting and stopping at a rock-solid **20 CPS**.

### 2. 📦 Distrobox & Container Tracking
Custom `fastfetch` setup that cleanly parses active Distrobox container counts and package densities using structured box-drawing borders (`┌───┐`, `├───┤`).

### 3. 🎮 Gaming Optimization
Includes automated `gamescope` wrapper scripts automatically mapped via `STEAM_COMPAT_INVOKER` to isolate and optimize environment parameters cleanly.

---

## 🚀 Quick Start / Deployment

### 1. Bootstrap the System
If you are on a fresh CachyOS installation, ensure your fundamental user groups are configured for input manipulation:

```bash
# Add user to input group for ydotool functionality
sudo usermod -aG input $USER
