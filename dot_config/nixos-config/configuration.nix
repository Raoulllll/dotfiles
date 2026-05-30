{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  powerManagement.cpuFreqGovernor = "amd-pstate-epp";

  services.scx.enable = true;
  services.scx.scheduler = "scx_lavd";

  hardware.graphics = { enable = true; enable32Bit = true; };
  services.xserver.videoDrivers = [ "amdgpu" ];

  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_CH.UTF-8"; LC_IDENTIFICATION = "de_CH.UTF-8";
    LC_MEASUREMENT = "de_CH.UTF-8"; LC_MONETARY = "de_CH.UTF-8";
    LC_NAME = "de_CH.UTF-8"; LC_NUMERIC = "de_CH.UTF-8";
    LC_PAPER = "de_CH.UTF-8"; LC_TELEPHONE = "de_CH.UTF-8";
    LC_TIME = "de_CH.UTF-8";
  };
  
  services.xserver.xkb = { layout = "ch"; variant = "de"; };
  console.keyMap = "sg";

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  security.pam.services.sddm.enableKwallet = true;
  environment.variables = { 
    CHROME_KEYRING = "kwallet6"; 
    EDITOR = "micro"; VISUAL = "micro"; BROWSER = "brave"; TERMINAL = "ghostty"; 
  };

  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "text/plain" = "micro.desktop";
  };

  fileSystems."/home/roehl/Vault" = { device = "/dev/disk/by-uuid/95aba3f0-430f-4c68-b976-913409565258"; fsType = "ext4"; options = [ "users" "nofail" "noatime" ]; };
  fileSystems."/mnt/BIG" = { device = "/dev/disk/by-uuid/445515f0-70a3-4cee-a4af-54aa663eddef"; fsType = "btrfs"; options = [ "users" "nofail" "noatime" "compress=zstd" ]; };

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 7d"; };
  nixpkgs.config.allowUnfree = true;

  services.flatpak.enable = true;
  services.hardware.openrgb.enable = true;
  services.samba.enable = true;
  services.input-remapper.enable = true;
  
  programs.fish.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.kdeconnect.enable = true;
  programs.ydotool.enable = true;
  programs.gamescope.enable = true;
  
  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    enable = true;
    serviceConfig = { ExecStart = "${pkgs.lact}/bin/lact daemon"; };
    wantedBy = [ "multi-user.target" ];
  };

  virtualisation = { docker.enable = true; podman.enable = true; waydroid.enable = true; libvirtd.enable = true; };
  services.pipewire = { enable = true; alsa.enable = true; pulse.enable = true; };

  users.users.roehl = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "docker" "libvirtd" "kvm" "ydotool" "input" ];
    shell = pkgs.fish;
  };

home-manager.users.roehl = { lib, ... }: {
    home.stateVersion = "24.05";
    home.enableNixpkgsReleaseCheck = false;

    programs.plasma = {
      enable = true;
      shortcuts = {
        "services/org.kde.brave-browser.desktop"."_launch" = "Meta+B";
        "services/org.kde.spectacle.desktop"."_launch" = "Print";
        "kwin"."Window Close" = "Meta+Q";
        "kwin"."Window Maximize" = "Meta+Up";
        
        # Shortcuts must be defined as "Command Name" = "Key"
        # The command itself is usually defined separately in Plasma or 
        # triggered via a different method. 
        # For simple command-based triggers in Plasma:
        "commands" = {
          "Type Raoul" = "${pkgs.ydotool}/bin/ydotool type 'Raoul ist cool5'";
          "Run Autoclicker" = "/home/roehl/scripts/autoclicker.py";
        };
      };
    };
  };

  fonts.packages = with pkgs; [ noto-fonts noto-fonts-cjk-sans noto-fonts-color-emoji inter nerd-fonts.jetbrains-mono nerd-fonts.meslo-lg ];

  environment.systemPackages = with pkgs; [
    git gh chezmoi micro ghostty kitty fastfetch starship btop yazi ripgrep atuin cbonsai cowsay duf pv stow topgrade wget unzip unrar rsync yt-dlp eza bat zoxide fd fzf jq wl-clipboard
    brave firefox vscodium obs-studio qbittorrent vesktop onlyoffice-desktopeditors winboat mpv
    mangohud distrobox virt-manager protonup-qt mgba spicetify-cli lact cifs-utils nfs-utils evtest
    input-remapper
  ];

  system.stateVersion = "24.05";
}
