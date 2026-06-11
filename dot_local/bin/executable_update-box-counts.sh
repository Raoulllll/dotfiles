#!/usr/bin/env bash
# Dynamic counts for your specific containers
echo "alpine-box (apk): $(distrobox enter alpine-box -- apk info 2>/dev/null | wc -l)" > ~/.cache/distrobox-pkg-counts
echo "davincibox (dpkg): $(distrobox enter davincibox -- dpkg -l 2>/dev/null | grep -c '^ii')" >> ~/.cache/distrobox-pkg-counts
echo "Ubuntu-24.04 (dpkg): $(distrobox enter Ubuntu-24.04 -- dpkg -l 2>/dev/null | grep -c '^ii')" >> ~/.cache/distrobox-pkg-counts
echo "arch-sandbox (pacman): $(distrobox enter arch-sandbox -- pacman -Q 2>/dev/null | wc -l)" >> ~/.cache/distrobox-pkg-counts
echo "debian-sid (dpkg): $(distrobox enter debian-sid -- dpkg -l 2>/dev/null | grep -c '^ii')" >> ~/.cache/distrobox-pkg-counts
