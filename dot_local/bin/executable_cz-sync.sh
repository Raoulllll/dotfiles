#!/bin/bash
set -euo pipefail

# Navigate to chezmoi source directory
cd "$(chezmoi source-path)"

# Re-add all tracked files that have changed in the home directory
chezmoi re-add --recursive

# Check if there are changes to commit
if ! git diff --quiet || ! git diff --cached --quiet; then
    # Stage all changes
    git add .

    # Commit with timestamp
    git commit -m "Auto backup: $(date -Iseconds)"

    # Push to remote (e.g., GitHub)
    git push
else
    echo "No changes to commit."
fi   
