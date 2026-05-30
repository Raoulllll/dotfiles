#!/usr/bin/env bash

echo "Starting First-Time Setup..."

# Ensure GitHub CLI is actually installed before trying to use it
if command -v gh &> /dev/null; then
    # Check if we are already logged in
    if ! gh auth status &>/dev/null; then
        echo "Hold up! We need to authenticate with GitHub so you can push updates later."
        gh auth login -p https -w
    else
        echo "GitHub CLI is already authenticated."
    fi

    # Set up Git to use the GitHub CLI for credentials silently
    git config --global credential.helper "!gh auth git-credential"
    echo "Git credential helper configured."
else
    echo "Warning: GitHub CLI (gh) is not installed. Please add it to your configuration.nix!"
fi
