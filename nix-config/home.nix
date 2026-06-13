{ pkgs, ... }:

{
  home.username = "roehl";
  home.homeDirectory = "/home/roehl";
  home.stateVersion = "23.11";

  # Nix handles ONLY the installation of these tools
  home.packages = with pkgs; [
    htop
    git
    ripgrep
    fastfetch
    eza
    starship
    zoxide
    micro  # Added micro since you use it in your nano function
  ];

  # Just ensures your local scripts are in the PATH
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
