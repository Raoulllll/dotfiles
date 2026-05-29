{
  description = "Declarative AMD Ryzen 9 9950X3D + Radeon 7900 XTX Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs = { self, nixpkgs, nix-cachyos-kernel, ... }@inputs: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        {
          nixpkgs.overlays = [ nix-cachyos-kernel.overlays.default ];
          
          # Use binary caches so your local processor doesn't compile the kernel from scratch
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
