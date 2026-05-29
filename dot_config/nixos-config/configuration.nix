{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # Systemd Bootloader Infrastructure
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages-cachyos-latest;
  powerManagement.cpuFreqGovernor = "amd-pstate-epp";

  # Asymmetric 3D V-Cache Scheduling (Prioritizing CCD0 for Gaming)
  services.scx.enable = true;
  services.scx.scheduler = "scx_lavd";

  # Pure Open-Source Graphics Stack (Mesa / RADV 32-bit enabled)
  hardware.graphics = { enable = true; enable32Bit = true; };
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Regional & Localization Parameters
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "de_CH.UTF-8";
  
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  # Headless Chromium/Brave Keyring Persistence Fixes
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
  # Primary Vault Mount (Ext4, 3.6T)
  fileSystems."/home/roehl/Vault" = {
    device = "/dev/disk/by-uuid/95aba3f0-430f-4c68-b976-913409565258";
    fsType = "ext4"; 
    options = [ "users" "nofail" "noatime" ];
  };

  # Secondary BIG Mount (BTRFS, 3.6T)
  fileSystems."/mnt/BIG" = {
    device = "/dev/disk/by-uuid/445515f0-70a3-4cee-a4af-54aa663eddef";
    fsType = "btrfs";
    options = [ "users" "nofail" "noatime" "compress=zstd" ];
  };

  # Automatically optimize the store and run garbage collection weekly
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # --- SYSTEM SERVICES & VIRTUALIZATION ---
  services.flatpak.enable = true;
  services.hardware.openrgb.enable = true;
  services.samba.enable = true;
  
  programs.fish.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.kdeconnect.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation.libvirtd.enable = true;

  services.pipewire = { enable = true; alsa.enable = true; pulse.enable = true; };

  # User Account Boundaries
  users.users.roehl = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "docker" "libvirtd" "kvm" ];
    shell = pkgs.fish;
  };

  # --- FONTS ---
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    inter
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
  ];

  # --- PACKAGES ---
  environment.systemPackages = with pkgs; [
    # Terminal & CLI Tools
    git gh chezmoi micro ghostty fastfetch starship btop yazi ripgrep
    atuin cbonsai cowsay duf pv stow topgrade wget unzip unrar rsync yt-dlp
    eza bat zoxide fd
    
    # Core Applications
    # brave # -> Uncomment on primary deployment
    firefox vscodium obs-studio qbittorrent spotify vesktop onlyoffice-bin
    
    # Utilities & Gaming
    mangohud distrobox virt-manager protonup-qt mgba
  ];

  system.stateVersion = "24.05"; # Keep this exactly as is, it dictates state compatibility, not package versions.
}
