#source /usr/share/cachyos-fish-config/cachyos-config.fish

#overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
set -g fish_greeting
starship init fish | source
# Force Steam compatibility layers to automatically pass through your gamescope container
set -gx STEAM_COMPAT_INVOKER "$HOME/.local/bin/game-wrapper"
# Direct all security calls cleanly to the GNOME Secret Service backend
set -gx PASSWORD_STORE "gnome-keyring"
# Automated clean passing rule for Cider launcher binary
set -gx TOKEN "0.Al5idZKPpNz5mb+OFh+ho5/9zunUKrG7lSNeAN8CQ9tPwjy/2VYGbDcnZVYMdf8eDRbREP1eR/e8ytABMllcJs/WIViVZSJOGzU7rqNH9yAKl2/2Np81vrsSbNoiBCUg2qAQ/D1+0MV77FgI9RG9Jps9dUvZDuPWA0ai2Gm9ihS4DHUX+1zD9Wz7iM7e78tEfXhZn3u3JC/ON+Emr+LAMXp28vLfTkP64LIS7XN2UnsLf4uzSQ=="
alias amusic="brave --app=https://music.apple.com"
# Automatically route all Steam game launches through your local Gamescope wrapper
set -gx STEAM_COMPAT_INVOKER "$HOME/.local/bin/steam-gamescope-wrapper"


fastfetch
# 2. Modern replacements for the classic 'ls' tool using eza
if command -v eza > /dev/null
    function ls --description "Alias for eza"
        eza --icons --grid --group-directories-first $argv
    end

    function ll --description "Detailed list format with git metrics"
        eza --icons --long --header --git --group-directories-first $argv
    end

    function la --description "Detailed list including hidden files"
        eza --icons --long --header --all --git --group-directories-first $argv
    end

    function tree --description "Visual folder architecture breakdown"
        eza --icons --tree --level=3 --group-directories-first $argv
    end
end

# 3. 'bat' overrides for 'cat'
if command -v bat > /dev/null
    function cat --description "Alias for bat"
        bat --paging=never $argv
    end
end

# 4. 'zoxide' initializing (replaces 'cd' natively)
if command -v zoxide > /dev/null
    zoxide init fish | source
end

# 5. Quick btop shortcut
if command -v btop > /dev/null
    alias top="btop"
end


# Memorable shortcut to back up all system dotfiles to GitHub
alias backup="~/.local/bin/cz-sync.sh"

function fish_user_key_bindings
    bind \cl 'clear; ~/.local/bin/fetch-layout; commandline -f repaint'
end
# Add this to your ~/.config/fish/config.fish
fish_add_path -m ~/.local/bin
function track
    if test (count $argv) -eq 0
        echo "Usage: track <file_or_directory>"
    else
        # We use a loop so you can track multiple files at once if you want
        for file in $argv
            chezmoi add $file
            echo "Tracked: $file"
        end
    end
end

function sfish
    source ~/.config/fish/config.fish
end

function nano
    micro $argv
end
