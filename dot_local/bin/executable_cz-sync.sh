#!/usr/bin/env bash

# 1. Force chezmoi to update its source copy from your live files
# This ensures that edits to tracked files are actually registered
chezmoi add ~/.local/bin/cz-sync.sh

# 2. Now check if Git has new commits to make
if [ -n "$(chezmoi git -- status --porcelain)" ]; then
    echo "Changes detected! Syncing to GitHub..."
    chezmoi git -- add .
    chezmoi git -- commit -m "Auto-backup (CachyOS): $(date '+%Y-%m-%d %H:%M:%S')"
    chezmoi git -- push
    echo "Sync complete!"
else
    echo "Everything is already clean and backed up."
fi
