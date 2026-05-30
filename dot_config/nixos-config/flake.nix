{
  description = "Declarative AMD Ryzen 9 9950X3D + Radeon 7900 XTX Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    sddm-astronaut.url = "github:keyitdev/sddm-astronaut-theme";
    sddm-astronaut.flake = false; # This is just a collection of assets, not a Nix flake;
    plasma-manager = {
        url = "github:nix-community/plasma-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
  };
 
  outputs = { self, nixpkgs, nix-cachyos-kernel, home-manager, plasma-manager,
              spicetify-nix, nix-index-database, ... }@inputs: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        nix-index-database.nixosModules.nix-index
        spicetify-nix.nixosModules.default
        
        # Home Manager Module
        home-manager.nixosModules.home-manager {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.extraSpecialArgs = { inherit inputs; };
                  home-manager.users.roehl = {
                    imports = [ plasma-manager.homeModules.plasma-manager ];
                    # CORRECT LOCATION:
                    
                  };
                }

        # Kernel and Cache module block
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
      ];
    };
  };
}
