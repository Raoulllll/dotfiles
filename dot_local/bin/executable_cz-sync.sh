#!/usr/bin/env bash
chezmoi add ~/.local/bin/*
chezmoi re-add
chezmoi git -- add .
chezmoi git -- commit -m "Auto-backup from NixOS"
chezmoi git -- push
