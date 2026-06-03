{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  # Assign the correct packages for Spicetify Themes
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ ./hardware-configuration.nix ];

  ### --- BOOT & KERNEL ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  powerManagement.cpuFreqGovernor = "amd-pstate-epp";

  ### --- SYSTEM PERFORMANCE & HARDWARE ---
  services.scx.enable = true;
  services.scx.scheduler = "scx_lavd";
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.hardware.openrgb.enable = true;

  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    wantedBy = [ "multi-user.target" ];
  };

  ### --- NETWORKING ---
  networking.networkmanager.enable = true;
  # Optional: Define your hostname here if you want it to be something specific
  networking.hostName = "nixos-desktop";
  # Open ports for DHCP (67) and DNS (53) so your phone can get an IP
  networking.firewall.allowedUDPPorts = [
    53
    67
    config.services.tailscale.port
  ];
  networking.firewall.allowedTCPPorts = [ 53 ];

  # Point to your untracked secret file
  networking.networkmanager.ensureProfiles.environmentFiles = [
    "/home/roehl/.config/nixos-config/hotspot-secret.env"
  ];

  networking.networkmanager.ensureProfiles.profiles = {
    "PC-Hotspot" = {
      connection = {
        id = "PC-Hotspot";
        type = "wifi";
        autoconnect = true;
        autoconnect-priority = 0;
      };
      wifi = {
        mode = "ap";
        ssid = "Roehl"; # You can leave the SSID plain text here
      };
      wifi-security = {
        key-mgmt = "wpa-psk";
        # Reference the variable from your .env file
        psk = "$HOTSPOT_PASSWORD";
      };
      ipv4 = {
        method = "shared";
      };
      ipv6 = {
        method = "shared";
      };
    };
  };

  ### --- LOCALIZATION & KEYBOARD ---
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

  ### --- ENVIRONMENT, XDG & FILESYSTEMS ---
  environment.variables = {
    CHROME_KEYRING = "kwallet6";
    EDITOR = "micro";
    VISUAL = "micro";
    BROWSER = "brave";
    TERMINAL = "kitty";
  };

  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "text/plain" = "micro.desktop";
  };

  fileSystems."/home/roehl/Vault" = {
    device = "/dev/disk/by-uuid/95aba3f0-430f-4c68-b976-913409565258";
    fsType = "ext4";
    options = [
      "users"
      "nofail"
      "exec"
      "noatime"
    ];
  };

  fileSystems."/home/roehl/BIG" = {
    device = "/dev/disk/by-uuid/445515f0-70a3-4cee-a4af-54aa663eddef";
    fsType = "btrfs";
    options = [
      "users"
      "nofail"
      "exec"
      "noatime"
      "compress=zstd"
    ];
  };

  fileSystems."/mnt/cachyos" = {
    device = "/dev/disk/by-uuid/b98daef4-8e1d-4a3f-8c5d-225261bf2a99";
    fsType = "btrfs";
    options = [
      "users"
      "nofail"
      "noatime"
      "x-systemd.automount"
      "compress=zstd"
    ];
  };

  ### --- NIX SETTINGS ---
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nixpkgs.config.allowUnfree = true;

  ### --- SERVICES & VIRTUALIZATION ---
  services.flatpak.enable = true;
  services.tailscale.enable = true;
  services.keyd = {
    enable = true;
    keyboards.logitech = {
      # Strictly target the Logitech receiver ONLY.
      ids = [ "046d:40b5" ];
      settings.main = {
        f13 = "macro(S-r a o u l space i s t space c o o l 5)";
      };
    };
  };
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    package = pkgs.ollama-rocm; # Select the CUDA variant
    openFirewall = true;
    # loadModels = [ "llama3.2:3b" ];
  };
  services.samba.enable = true;
  services.input-remapper.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  virtualisation = {
    docker.enable = true;
    podman.enable = true;
    libvirtd.enable = true;
  };

  ### --- DESKTOP ENVIRONMENT (PLASMA 6) ---
  services.desktopManager.plasma6.enable = true;
  security.pam.services.sddm.enableKwallet = true;

  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    package = lib.mkForce pkgs.kdePackages.sddm;
    extraPackages = [
      pkgs.qt6.qtsvg
      pkgs.qt6.qtdeclarative
      pkgs.qt6.qtmultimedia
    ];
  };

  ### --- USER CONFIGURATION ---
  users.users.roehl = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "docker"
      "libvirtd"
      "kvm"
      "ydotool"
      "input"
    ];
    shell = pkgs.fish;
  };

  ### --- SYSTEM PROGRAMS ---
  programs.fish.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.kdeconnect.enable = true;
  programs.ydotool.enable = true;
  programs.gamescope.enable = true;

  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enable = true;

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.dribbblish;
    colorScheme = "tokyo-night";
  };

  ### --- HOME MANAGER ---
  home-manager.users.roehl =
    { lib, ... }:
    {
      imports = [
        inputs.plasma-manager.homeManagerModules.plasma-manager

      ];

      home.stateVersion = "24.05";
      home.enableNixpkgsReleaseCheck = false;
      xdg.configFile."fontconfig/conf.d/10-hm-fonts.conf".force = true;

      # --- Distrobox Package Counter Background Service ---
      systemd.user.services.distrobox-pkg-counter = {
        Unit = {
          Description = "Update Distrobox package counts for fastfetch";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "/home/roehl/.local/bin/distrobox-pkg-counter.sh";
        };
      };

      systemd.user.timers.distrobox-pkg-counter = {
        Unit = {
          Description = "Run distrobox-pkg-counter every hour";
        };
        Timer = {
          OnCalendar = "hourly";
          Persistent = true;
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };

      programs.plasma = {
        enable = true;
        shortcuts = {
          "services/org.kde.brave-browser.desktop"."_launch" = "Meta+B";
          # Keep the standard print key for a full screenshot
          "services/org.kde.spectacle.desktop"."_launch" = "Print";
          # Add this line specifically for the region screenshot
          "services/org.kde.spectacle.desktop"."RectangularRegionScreenShot" = "Meta+Shift+S";

          "kwin"."Window Close" = "Meta+Q";
          "kwin"."Window Maximize" = "Meta+Up";
          "commands" = {
            "Type Raoul" = "${pkgs.ydotool}/bin/ydotool type 'Raoul ist cool5'";
            "Run Autoclicker" = "/home/roehl/scripts/autoclicker.py";
          };
        };
      };
    };

  ### --- FONTS & SYSTEM PACKAGES ---
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    inter
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
  ];

  environment.systemPackages = with pkgs; [
    # CLI Tools
    git
    gh
    chezmoi
    micro
    btop
    yazi
    ripgrep
    atuin
    fd
    fzf
    jq
    zoxide
    eza
    bat
    wget
    unzip
    unrar
    rsync
    yt-dlp
    pv
    duf
    wl-clipboard
    nh
    stow
    topgrade
    dnsmasq
    iptables
    tailscale
    ethtool
    quickshell
    keyd
    nil
    nixd

    # Terminals & Prompts
    kitty
    fastfetch
    starship
    cbonsai
    cowsay

    # GUI Apps
    brave
    firefox
    vscode
    obs-studio
    qbittorrent
    vesktop
    onlyoffice-desktopeditors
    winboat
    mpv
    spotify
    whatip
    komikku
    obsidian
    proton-vpn
    ferdium
    zed-editor

    # Gaming & System Utils
    mangohud
    distrobox
    virt-manager
    protonup-qt
    mgba
    wine
    lact
    cifs-utils
    nfs-utils
    evtest
    input-remapper
    kdePackages.partitionmanager
    spicetify-cli
    ollama

    # Custom SDDM Theme
    (pkgs.runCommand "sddm-theme-astronaut" { } ''
      mkdir -p $out/share/sddm/themes/sddm-astronaut-theme
      cp -r ${inputs.sddm-astronaut}/* $out/share/sddm/themes/sddm-astronaut-theme/
    '')
  ];

  system.stateVersion = "24.05";
}
