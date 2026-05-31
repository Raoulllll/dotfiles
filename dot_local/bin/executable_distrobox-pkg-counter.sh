#!/usr/bin/env bash

CACHE_FILE="$HOME/.cache/distrobox-pkg-counts"

# Ensure the cache directory exists
mkdir -p "$(dirname "$CACHE_FILE")"

# Create a temporary file to avoid fastfetch reading an empty file while this runs
TMP_FILE=$(mktemp)

# Helper functions to silently run the correct package manager query
count_apk() { distrobox-enter "$1" -- apk info 2>/dev/null | wc -l || echo "0"; }
count_rpm() { distrobox-enter "$1" -- rpm -qa 2>/dev/null | wc -l || echo "0"; }
count_dpkg() { distrobox-enter "$1" -- dpkg-query -f '${binary:Package}\n' -W 2>/dev/null | wc -l || echo "0"; }
count_pacman() { distrobox-enter "$1" -- pacman -Qq 2>/dev/null | wc -l || echo "0"; }

# Append results to the temp file
echo "alpine-box: $(count_apk alpine-box)" >> "$TMP_FILE"
echo "davincibox: $(count_rpm davincibox)" >> "$TMP_FILE"
echo "Ubuntu-24.04: $(count_dpkg Ubuntu-24.04)" >> "$TMP_FILE"
echo "arch-sandbox: $(count_pacman arch-sandbox)" >> "$TMP_FILE"
echo "debian-sid: $(count_dpkg debian-sid)" >> "$TMP_FILE"

# Atomically replace the old cache with the new data
mv "$TMP_FILE" "$CACHE_FILE"
