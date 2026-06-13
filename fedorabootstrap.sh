#!/bin/bash

# =============================================================================
# Fedora Migration Bootstrap Script (Updated)
# This script automates the setup of RPM Fusion, Copr repos, and core packages.
# All commands include '-y' for non-interactive, unattended installation.
# =============================================================================

# Ensure the script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo ./bootstrap.sh)"
  exit 1
fi

echo "🚀 Starting Fedora Bootstrap Process (Unattended Mode)..."

# -----------------------------------------------------------------------------
# 1. System Update
# -----------------------------------------------------------------------------
echo -e "\n[1/5] Updating system packages..."
dnf update -y

# -----------------------------------------------------------------------------
# 2. Enable RPM Fusion (Essential for Codecs and Drivers)
# -----------------------------------------------------------------------------
echo -e "\n[2/5] Enabling RPM Fusion (Free and Non-Free)..."
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
               https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# -----------------------------------------------------------------------------
# 3. Enable Copr Repositories (For specialized Arch-like tools)
# -----------------------------------------------------------------------------
echo -e "\n[3/5] Enabling Copr repositories..."
# lact for AMD GPU control
dnf copr enable -y ryanbv/lact
# anicy for process priority management
dnf copr enable -y ryanbv/anicy-cpp
# keyd for custom keyboard remapping
dnf copr enable -y dbe/keyd

# -----------------------------------------------------------------------------
# 4. Install Core Packages
# -----------------------------------------------------------------------------
echo -e "\n[4/5] Installing core packages and drivers..."

# Standard system utilities and networking
dnf install -y \
    nfs-utils \
    avahi \
    bluez \
    bluez-tools \
    libvirt \
    virt-manager \
    tailscale \
    docker-ce \
    docker-compose-plugin \
    git \
    wget \
    curl

# Specialized Hardware/Performance Tools (Removed waydroid as requested)
dnf install -y \
    lact \
    anicy-cpp \
    keyd

# -----------------------------------------------------------------------------
# 5. Post-Install Service Setup
# -----------------------------------------------------------------------------
echo -e "\n[5/5] Enabling and starting system services..."

# Enable standard services
systemctl enable --now avahi-daemon
systemctl enable --now bluetooth
systemctl enable --now libvirtd
systemctl enable --now docker

# Enable hardware/performance services
systemctl enable --now lactd
systemctl enable --now anicy-cpp
systemctl enable --now keyd

echo -e "\n✅ Bootstrap Complete!"
echo "-----------------------------------------------------------------------------"
echo "NEXT STEPS:"
echo "1. REBOOT your system to apply kernel/driver changes."
echo "2. Install Ollama manually: curl -fsSL https://ollama.com/install.sh | sh"
echo "3. Add your user to the docker group: sudo usermod -aG docker $USER"
echo "4. Copy your custom config files (/etc/keyd, etc.)"
echo "5. Setup your NFS/TrueNAS mounts in /etc/fstab."
echo "-----------------------------------------------------------------------------"
