#source /usr/share/cachyos-fish-config/cachyos-config.fish

# Initialize starship
starship init fish | source

# --- ENVIRONMENT SETTINGS ---
# Automatically route all Steam game launches through your local Gamescope wrapper
set -gx STEAM_COMPAT_INVOKER "$HOME/.local/bin/steam-gamescope-wrapper"

### 1. PATH & INITIALIZATION
fish_add_path -m ~/.local/bin

# Initialize smart tools
if command -v zoxide > /dev/null
    zoxide init fish | source
end

### 2. FUNCTIONS (The "Power" Tools)
# These replace commands or add complex behavior

function ls --description "Alias for eza"
    eza --icons --grid --group-directories-first $argv
end

function ll --description "Detailed list"
    eza --icons --long --header --git --group-directories-first $argv
end

function la --description "List all"
    eza --icons --long --header --all --git --group-directories-first $argv
end

function tree --description "Folder tree"
    eza --icons --tree --level=3 --group-directories-first $argv
end

function nano
    micro $argv
end

function sfish --description "Reload fish config"
    source ~/.config/fish/config.fish
end

function track --description "Add file to chezmoi"
    for file in $argv
        chezmoi add $file
        echo "Tracked: $file"
    end
end

function fish_user_key_bindings
    bind \cl 'clear; ~/.local/bin/fetch-layout; commandline -f repaint'
end

function nixin
    pushd ~/nix-config
    # We add .#roehl to tell Home Manager which configuration to use
    nix run github:nix-community/home-manager -- switch --flake .#roehl
    popd
end

### 3. ABBREVIATIONS (The "Shortcuts")
# Navigation
abbr -a home 'cd ~'
abbr -a conf 'cd ~/.config'
abbr -a scripts 'cd ~/scripts'
abbr -a vault 'cd ~/Vault'
abbr -a big 'cd /mnt/BIG'
abbr -a root 'cd /'

# Directory Shortcuts
abbr -a ..   'cd ..'
abbr -a ...  'cd ../..'
abbr -a .... 'cd ../../..'

# File/Config Management
abbr -a mfish 'micro ~/.config/fish/config.fish'
abbr -a top   'btop'
abbr -a logs  'journalctl -p 3 -xb'
abbr -a backup '~/.local/bin/cz-sync.sh'
abbr -a clean 'nh clean all'

### 4. GREETING
set -g fish_greeting ""
fastfetch

# SSH Agent automatisch starten
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

# Schlüssel beim ersten Start automatisch laden
if status is-interactive
    if not ssh-add -l > /dev/null 2>&1
        ssh-add ~/.ssh/id_ed25519 2>/dev/null
    end
end
