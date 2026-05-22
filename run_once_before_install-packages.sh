#!/bin/bash

echo "=== Starting Core Application Installation ==="

# 1. Update system repositories
sudo pacman -Sy

# 2. Install native official packages if missing
echo "Checking official packages..."
for pkg in fastfetch micro ghostty brave-browser-nightly; do
    if ! pacman -Qi $pkg &> /dev/null; then
        echo "Installing $pkg..."
        sudo pacman -S --noconfirm $pkg
    else
        echo "$pkg is already installed."
    fi
done

echo "=== Installation Sync Complete ==="
