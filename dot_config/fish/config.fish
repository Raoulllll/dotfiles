source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
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
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
set -gx EDITOR micro
