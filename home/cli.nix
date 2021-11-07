{ pkgs, inputs, ... }:

{
  imports = [
    ./neovim
  ];

  home.packages = with pkgs; [
    nix-index
    nix-tree
    unzip
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
