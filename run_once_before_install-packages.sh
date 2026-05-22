#!/bin/bash

echo "=== System Configuration ==="
SCRIPT_DIR="$(dirname "$0")"

# 1. Sync custom pacman config if present
if [ -f "$SCRIPT_DIR/pacman.conf" ]; then
    echo "Syncing custom pacman.conf to /etc/..."
    sudo cp "$SCRIPT_DIR/pacman.conf" /etc/pacman.conf
fi

echo "=== Starting Bulk Package Installation ==="

# 2. Update system repositories
sudo pacman -Sy

# 3. Mass-install every package tracked in your text list
if [ -f "$SCRIPT_DIR/pkglist.txt" ]; then
    echo "Installing explicitly tracked packages from list..."
    # --needed tells pacman to skip anything you already have installed
    sudo pacman -S --needed --noconfirm - < "$SCRIPT_DIR/pkglist.txt"
fi

# 4. Enforce that your absolute favorites are present no matter what
echo "Ensuring core utilities..."
sudo pacman -S --needed --noconfirm fastfetch micro ghostty brave-browser-nightly

echo "=== Installation Sync Complete ==="
