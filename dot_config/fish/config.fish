
# Initialize starship
starship init fish | source

# --- ENVIRONMENT SETTINGS ---
# Automatically route all Steam game launches through your local Gamescope wrapper
if test -x "$HOME/.local/bin/steam-gamescope-wrapper"
    set -gx STEAM_COMPAT_INVOKER "$HOME/.local/bin/steam-gamescope-wrapper"
end

### 1. PATH & INITIALIZATION
fish_add_path -m ~/.local/bin

# Initialize smart tools
if command -v zoxide > /dev/null
    zoxide init fish | source
end

### 2. FUNCTIONS (The "Power" Tools)
# These replace commands or add complex behavior

function ls --description "Alias for eza"
    if command -q eza
        eza --icons --grid --group-directories-first $argv
    else
        command ls $argv
    end
end

function ll --description "Detailed list"
    if command -q eza
        eza --icons --long --header --git --group-directories-first $argv
    else
        command ls -lh $argv
    end
end

function la --description "List all"
    if command -q eza
        eza --icons --long --header --all --git --group-directories-first $argv
    else
        command ls -lah $argv
    end
end

function tree --description "Folder tree"
    if command -q eza
        eza --icons --tree --level=3 --group-directories-first $argv
    else
        command tree $argv
    end
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


### 3. ABBREVIATIONS (The "Shortcuts")
# Navigation
abbr -a home 'cd ~'
abbr -a conf 'cd ~/.config'
abbr -a scripts 'cd ~/.local/bin'
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

### 4. GREETING
set -g fish_greeting ""
if status is-interactive; and command -q fastfetch
    fastfetch
end

# SSH agent: Fedora's systemd user socket (ssh-agent.socket), also set in ~/.config/environment.d/sshagent.conf
if not test -S "$SSH_AUTH_SOCK"
    set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
end

# Schlüssel beim ersten Start automatisch laden
if status is-interactive
    if not ssh-add -l > /dev/null 2>&1
        # asks once per login for the passphrases (id_ed25519: servers + Forgejo, id_chezmoi: GitHub)
        ssh-add ~/.ssh/id_ed25519 ~/.ssh/id_chezmoi
    end
end
set -gx EDITOR micro
set -gx VISUAL micro
for brew in /home/linuxbrew/.linuxbrew/bin/brew /opt/homebrew/bin/brew
    if test -x $brew
        $brew shellenv | source
        break
    end
end

# Docker Desktop, only where installed (the Mac)
test -d $HOME/.docker/bin; and fish_add_path -a $HOME/.docker/bin

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/roehl/.lmstudio/bin
# End of LM Studio CLI section
