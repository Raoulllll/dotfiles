{
  description = "My declarative Arch + Nix setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # 1. This defines your user configuration (for 'home-manager switch')
      homeConfigurations."roehl" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [ ./home.nix ];
      };

      # 2. This defines an actual package (this fixes the 'activationPackage' error)
      packages.${system}.default = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [ ./home.nix ];
      }.activationPackage;
    };
}
