#!/usr/bin/env bash

# Check for changes
if [ -n "$(chezmoi git -- status --porcelain)" ]; then
    echo "Changes detected! Updating tracked state and syncing to GitHub..."
    
    # 1. Update chezmoi's internal tracking for existing files
    chezmoi re-add
    
    # 2. Stage changes in the git repo
    chezmoi git -- add .
    
    # 3. Commit and push
    chezmoi git -- commit -m "Auto-backup (CachyOS): $(date '+%Y-%m-%d %H:%M:%S')"
    chezmoi git -- push
    
    echo "Sync complete!"
else
    echo "Everything is already clean and backed up."
fi
