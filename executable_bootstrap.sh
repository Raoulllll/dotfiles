#!/usr/bin/env bash

echo "Starting Post-Install Setup..."

# 1. Authenticate with GitHub
echo "Checking GitHub authentication..."
if ! gh auth status &>/dev/null; then
    echo "Please log in to GitHub to authorize Chezmoi:"
    gh auth login -p ssh -w
fi

# 2. Tell Git to use the GitHub CLI credential helper
git config --global credential.helper "!gh auth git-credential"

# 3. Pull and apply the blueprints
echo "Initializing Chezmoi..."
chezmoi init --apply https://github.com/Raoulllll/dotfiles.git

echo "Welcome Home!"
