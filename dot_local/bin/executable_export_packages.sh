#!/bin/bash

# Target destination inside your chezmoi repo
REPOS_FILE="$HOME/.local/share/chezmoi/pkglist.txt"

echo "Dumping explicitly installed system packages..."

# -Qe = Query explicitly installed packages
# -qn = quiet name (omits version numbers) from official repos
pacman -Qqen > "$REPOS_FILE"

echo "Saved $(wc -l < "$REPOS_FILE") packages to pkglist.txt!"
