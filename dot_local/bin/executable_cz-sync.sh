#!/usr/bin/env bash
#test
# Use --force to prevent interactive prompts from hanging the script
if [ -n "$(chezmoi git -- status --porcelain)" ]; then
    echo "Changes detected! Updating tracked state..."
    
    # Force re-add and force git add to prevent hangs
    chezmoi re-add --force
    chezmoi git -- add .
    
    echo "Syncing to GitHub..."
    chezmoi git -- commit -m "Auto-backup (CachyOS): $(date '+%Y-%m-%d %H:%M:%S')"
    chezmoi git -- push
    
    echo "Sync complete!"
else
    echo "Everything is already clean and backed up."
fi
