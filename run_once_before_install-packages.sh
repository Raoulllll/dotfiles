#!/bin/bash

echo "=== System Configuration ==="

# Get the directory where this script is currently running
SCRIPT_DIR="$(dirname "$0")"

# If a backed-up pacman.conf exists in our dotfiles, copy it to /etc/ safely
if [ -f "$SCRIPT_DIR/pacman.conf" ]; then
    echo "Syncing custom pacman.conf to /etc/..."
    sudo cp "$SCRIPT_DIR/pacman.conf" /etc/pacman.conf
fi

echo "=== Starting Core Application Installation ==="

# 1. Update system repositories using the newly synced config
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
