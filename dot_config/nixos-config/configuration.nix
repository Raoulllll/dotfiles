{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # Systemd Bootloader Infrastructure
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  powerManagement.cpuFreqGovernor = "amd-pstate-epp";

  # Asymmetric 3D V-Cache Scheduling (Prioritizing CCD0 for Gaming)
  services.scx.enable = true;
  services.scx.scheduler = "scx_lavd";

  # Pure Open-Source Graphics Stack
  hardware.graphics = { enable = true; enable32Bit = true; };
  services.xserver.videoDrivers = [ "amdgpu" ];

  # --- LANGUAGE & KEYBOARD (English UI, Swiss German Formats/Layout) ---
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_CH.UTF-8";
    LC_IDENTIFICATION = "de_CH.UTF-8";
    LC_MEASUREMENT = "de_CH.UTF-8";
    LC_MONETARY = "de_CH.UTF-8";
    LC_NAME = "de_CH.UTF-8";
    LC_NUMERIC = "de_CH.UTF-8";
    LC_PAPER = "de_CH.UTF-8";
    LC_TELEPHONE = "de_CH.UTF-8";
    LC_TIME = "de_CH.UTF-8";
  };
  
  services.xserver.xkb = {
    layout = "ch";
    variant = "de";
  };
  console.keyMap = "sg";

  # KDE Plasma 6
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  # Headless Keyring Persistence
  security.pam.services.sddm.enableKwallet = true;
  environment.variables.CHROME_KEYRING = "kwallet6";

  # Global Default Applications
  environment.variables = {
    EDITOR = "micro";
    VISUAL = "micro";
    BROWSER = "brave";
    TERMINAL = "ghostty";
  };

  # XDG Portal & MIME Default Apps
  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "x-scheme-handler/about" = "brave-browser.desktop";
    "x-scheme-handler/unknown" = "brave-browser.desktop";
    "text/plain" = "micro.desktop";
  };

  # --- STORAGE MOUNTS ---
  fileSystems."/home/roehl/Vault" = {
    device = "/dev/disk/by-uuid/95aba3f0-430f-4c68-b976-913409565258";
    fsType = "ext4"; 
    options = [ "users" "nofail" "noatime" ];
  };

  fileSystems."/mnt/BIG" = {
    device = "/dev/disk/by-uuid/445515f0-70a3-4cee-a4af-54aa663eddef";
    fsType = "btrfs";
    options = [ "users" "nofail" "noatime" "compress=zstd" ];
  };

  # Store Optimization
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Allow Proprietary Software (Fixed Unrar/Spotify error)
  nixpkgs.config.allowUnfree = true;

  # System Services & Virtualization
  services.flatpak.enable = true;
  services.hardware.openrgb.enable = true;
  services.samba.enable = true;
  
  programs.fish.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.kdeconnect.enable = true;
  programs.ydotool.enable = true;
  # Valve's Wayland Micro-compositor
  programs.gamescope.enable = true;
  
    # Enable the background daemon for the LACT AMDGPU Controller
    systemd.services.lact = {
      description = "AMDGPU Control Daemon";
      enable = true;
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
      };
      wantedBy = [ "multi-user.target" ];
    };

  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation.libvirtd.enable = true;

  services.pipewire = { enable = true; alsa.enable = true; pulse.enable = true; };

  users.users.roehl = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "docker" "libvirtd" "kvm" "ydotool" ];
    shell = pkgs.fish;
  };

  # --- FONTS ---
  # Reverted to legacy nomenclature if unstable syntax failed during trial
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    inter
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Meslo" ]; })
  ];

  # --- PACKAGES ---
  environment.systemPackages = with pkgs; [
    # Terminal & CLI Tools
    git gh chezmoi micro ghostty kitty fastfetch starship btop yazi ripgrep
    atuin cbonsai cowsay duf pv stow topgrade wget unzip unrar rsync yt-dlp
    eza bat zoxide fd fzf jq wl-clipboard
    
    # Core Applications & Media
    brave firefox vscodium obs-studio qbittorrent vesktop onlyoffice-desktopeditors
    stremio winboat mpv
    
    # Utilities & Gaming
    mangohud distrobox virt-manager protonup-qt mgba spicetify-cli lact
    
    # KDE Theme Engines
    kdePackages.kvantum
    catppuccin-kvantum
    
    # Network Storage Utilities
    cifs-utils nfs-utils
  ];

  system.stateVersion = "24.05"; 
}
