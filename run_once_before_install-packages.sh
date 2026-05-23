#!/bin/bash

echo "=== System Configuration ==="

# Define a completely hardcoded path that never resolves to empty
REPO_DIR="$HOME/.local/share/chezmoi"

# Sync custom pacman config if present
if [ -f "$REPO_DIR/pacman.conf" ]; then
    echo "Syncing custom pacman.conf to /etc/..."
    sudo cp "$REPO_DIR/pacman.conf" /etc/pacman.conf
fi

echo "=== Starting Bulk Package Installation ==="

# 2. Update system repositories
sudo pacman -Sy

# 3. Mass-install every package tracked in your text list
if [ -f "$REPO_DIR/pkglist.txt" ]; then
    echo "Installing explicitly tracked packages from list..."
    sudo pacman -S --needed --noconfirm - < "$REPO_DIR/pkglist.txt"
fi

# 4. Enforce that your absolute favorites are present no matter what
echo "Ensuring core utilities..."
sudo pacman -S --needed --noconfirm fastfetch micro ghostty brave-browser-nightly eza bat zoxide ripgrep fd btop

echo "=== Installation Sync Complete ==="
