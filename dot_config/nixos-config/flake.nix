{
  description = "Declarative AMD Ryzen 9 9950X3D + Radeon 7900 XTX Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    plasma-manager = {
        url = "github:nix-community/plasma-manager";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
      };
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = { self, nixpkgs, nix-cachyos-kernel, home-manager, plasma-manager, ... }@inputs: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
    modules = [
              ./configuration.nix
             # ... in your modules list inside flake.nix ...
              home-manager.nixosModules.home-manager {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  # Ensure this says homeModules (plural), not homeManagerModules
                  home-manager.users.roehl.imports = [ plasma-manager.homeModules.plasma-manager ];
                  home-manager.extraSpecialArgs = { inherit inputs; };
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
