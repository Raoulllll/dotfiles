{
  description = "Declarative AMD Ryzen 9 9950X3D + Radeon 7900 XTX Configuration";

  inputs = {
    # System
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
   
    # Modules
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Packages / Themes
    nix-gaming.url = "github:fufexan/nix-gaming";
    sddm-astronaut = {
      url = "github:keyitdev/sddm-astronaut-theme";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nix-cachyos-kernel, home-manager, ... }@inputs: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # Kernel Overlay and Cache
        {
          nixpkgs.overlays = [ nix-cachyos-kernel.overlays.default ];
          nix.settings = {
            substituters = [ "https://cache.garnix.io" "https://attic.xuyh0120.win/lantian" ];
            trusted-public-keys = [ 
              "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" 
              "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" 
            ];
          };
        }

        # Core System Config
        ./configuration.nix
        
        # Flake Modules
        inputs.nix-index-database.nixosModules.nix-index
        inputs.spicetify-nix.nixosModules.default

        # Home Manager Module Setup
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          # User-specific settings are handled inside configuration.nix
        }
      ];
    };
  };
}
