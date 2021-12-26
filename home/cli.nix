{ pkgs, inputs, ... }:

{
  imports = [
    ./modules/neovim
  ];

  home.packages = with pkgs; [
    nix-index
    nix-tree
    cachix
    unzip
    lazygit
    steam-run
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
