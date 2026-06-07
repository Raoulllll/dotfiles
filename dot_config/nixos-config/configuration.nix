{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  # Spicetify Themes
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  # Custom SDDM Theme Derivation
  sddm-astronaut-theme = pkgs.runCommand "sddm-theme-astronaut" { } ''
    mkdir -p $out/share/sddm/themes/sddm-astronaut-theme
    cp -r ${inputs.sddm-astronaut}/* $out/share/sddm/themes/sddm-astronaut-theme/
  '';
in
{
  imports = [ ./hardware-configuration.nix ];

  ### --- 1. BOOT & KERNEL ---
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  ### --- 2. HARDWARE & POWER ---
  hardware.bluetooth.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  powerManagement.cpuFreqGovernor = "amd-pstate-epp";

  ### --- 3. NETWORKING ---
  networking = {
    hostName = "nixos-desktop";
    networkmanager = {
      enable = true;
      ensureProfiles.environmentFiles = [ "/home/roehl/.config/nixos-config/hotspot-secret.env" ];
      ensureProfiles.profiles = {
        "PC-Hotspot" = {
          connection = {
            id = "PC-Hotspot";
            type = "wifi";
            autoconnect = true;
            autoconnect-priority = 0;
          };
          wifi = {
            mode = "ap";
            ssid = "Roehl";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$HOTSPOT_PASSWORD";
          };
          ipv4.method = "shared";
          ipv6.method = "shared";
        };
      };
    };
    firewall = {
      allowedTCPPorts = [
        53
        7007
        9001
      ];
      allowedUDPPorts = [
        53
        67
        config.services.tailscale.port
      ];
    };
  };

  ### --- 4. LOCALIZATION & CONSOLE ---
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
  console.keyMap = "sg";

  ### --- 5. FILESYSTEMS ---
  fileSystems = {
    "/home/roehl/Vault" = {
      device = "/dev/disk/by-uuid/95aba3f0-430f-4c68-b976-913409565258";
      fsType = "ext4";
      options = [
        "users"
        "nofail"
        "exec"
        "noatime"
      ];
    };
    "/home/roehl/BIG" = {
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
    "/mnt/cachyos" = {
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
    "/mnt/nas" = {
      device = "//192.168.0.100/NAS";
      fsType = "cifs";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=60"
        "x-systemd.device-timeout=5s"
        "x-systemd.mount-timeout=5s"
        "credentials=/root/smb-secrets"
        "uid=1000"
        "gid=100"
      ];
    };
  };

  ### --- 6. NIX SETTINGS ---
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nixpkgs.config.allowUnfree = true;

  ### --- 7. SERVICES ---
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "sddm-astronaut-theme";
      package = lib.mkForce pkgs.kdePackages.sddm;
      extraPackages = with pkgs.qt6; [
        qtsvg
        qtdeclarative
        qtmultimedia
      ];
    };
    xserver = {
      videoDrivers = [ "amdgpu" ];
      xkb = {
        layout = "ch";
        variant = "de";
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    keyd = {
      enable = true;
      keyboards.logitech = {
        ids = [ "046d:40b5" ];
        settings.main.f13 = "macro(S-r a o u l space i s t space c o o l 5)";
      };
    };
    scx = {
      enable = true;
      scheduler = "scx_lavd";
    };
    hardware.openrgb.enable = true;
    flatpak.enable = true;
    tailscale.enable = true;
    samba.enable = true;
    input-remapper.enable = true;
  };

  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    enable = true;
    serviceConfig.ExecStart = "${pkgs.lact}/bin/lact daemon";
    wantedBy = [ "multi-user.target" ];
  };

  security.pam.services.sddm.enableKwallet = true;

  ### --- 8. VIRTUALIZATION & CONTAINERS ---
  virtualisation = {
    libvirtd.enable = true;
    podman.enable = true;
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers = {
        immich-machine-learning = {
          image = "ghcr.io/immich-app/immich-machine-learning:release";
          ports = [ "3003:3003" ];
          volumes = [ "/var/lib/immich-ml-cache:/cache" ];
        };
        portainer-agent = {
          image = "portainer/agent:latest";
          ports = [ "9001:9001" ];
          volumes = [
            "/var/run/docker.sock:/var/run/docker.sock"
            "/var/lib/docker/volumes:/var/lib/docker/volumes"
          ];
        };
        dozzle-agent = {
          image = "amir20/dozzle:latest";
          cmd = [
            "agent"
            "--hostname"
            "NixOS-Desktop"
          ];
          ports = [ "7007:7007" ];
          volumes = [ "/var/run/docker.sock:/var/run/docker.sock:ro" ];
        };
      };
    };
  };

  ### --- 9. PROGRAMS ---
  programs = {
    fish.enable = true;
    steam.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
    kdeconnect.enable = true;
    ydotool.enable = true;
    nix-ld.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    spicetify = {
      enable = true;
      theme = spicePkgs.themes.dribbblish;
      colorScheme = "tokyo-night";
    };
  };

  ### --- 10. ENVIRONMENT & XDG ---
  environment.variables = {
    CHROME_KEYRING = "kwallet6";
    EDITOR = "micro";
    VISUAL = "micro";
    BROWSER = "brave";
    TERMINAL = "kitty";
  };

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "text/plain" = "micro.desktop";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };

  ### --- 11. SYSTEM PACKAGES & FONTS ---
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    inter
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
  ];

  environment.systemPackages = with pkgs; [
    # Custom Theme
    sddm-astronaut-theme

    # CLI Tools
    atuin
    bat
    btop
    cbonsai
    chezmoi
    cowsay
    dnsmasq
    duf
    ethtool
    eza
    fd
    fastfetch
    fzf
    gh
    git
    iptables
    jq
    micro
    nh
    nil
    nixd
    pv
    ripgrep
    rsync
    stow
    tailscale
    topgrade
    unzip
    unrar
    wget
    wl-clipboard
    yazi
    yt-dlp
    zoxide

    # Terminals & Prompts
    kitty
    starship
    quickshell
    keyd

    # GUI Apps
    brave
    ferdium
    firefox
    gnome-boxes
    komikku
    mpv
    obsidian
    obs-studio
    onlyoffice-desktopeditors
    proton-vpn
    qbittorrent
    spotify
    vesktop
    whatip
    winboat
    zed-editor

    # Gaming & System Utils
    cifs-utils
    distrobox
    evtest
    input-remapper
    kdePackages.partitionmanager
    lact
    mangohud
    mgba
    modrinth-app
    nfs-utils
    prismlauncher
    protonup-qt
    spicetify-cli
    virt-manager
    wine
  ];

  ### --- 12. USERS & HOME MANAGER ---
  users.users.roehl = {
    isNormalUser = true;
    shell = pkgs.fish;
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
  };

  home-manager.users.roehl =
    { lib, pkgs, ... }:
    {
      imports = [ inputs.plasma-manager.homeModules.plasma-manager ];
      home.stateVersion = "24.05";
      home.enableNixpkgsReleaseCheck = false;
      home.packages = with pkgs; [ r2modman ];

      xdg.configFile."fontconfig/conf.d/10-hm-fonts.conf".force = true;

      systemd.user.services.distrobox-pkg-counter = {
        Unit.Description = "Update Distrobox package counts for fastfetch";
        Service = {
          Type = "oneshot";
          ExecStart = "/home/roehl/.local/bin/distrobox-pkg-counter.sh";
        };
      };

      systemd.user.timers.distrobox-pkg-counter = {
        Unit.Description = "Run distrobox-pkg-counter every hour";
        Timer = {
          OnCalendar = "hourly";
          Persistent = true;
        };
        Install.WantedBy = [ "timers.target" ];
      };

      programs.plasma = {
        enable = true;
        shortcuts = {
          "services/org.kde.brave-browser.desktop"."_launch" = "Meta+B";
          "services/org.kde.spectacle.desktop"."_launch" = "Print";
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

  system.stateVersion = "24.05";
}
