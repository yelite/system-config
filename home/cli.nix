{ pkgs, inputs, ... }:

{
  imports = [
    ./neovim
  ];

  home.packages = with pkgs; [
    nix-index
    nix-tree
    cachix
    unzip
    lazygit
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
