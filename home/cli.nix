{ pkgs, inputs, ... }:

{
  imports = [
    ./neovim
  ];

  home.packages = with pkgs; [
    nix-index
    nix-tree
    unzip
    lazygit
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
