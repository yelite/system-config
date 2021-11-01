{ pkgs, inputs, ... }:

{
  imports = [
    ./neovim
  ];

  home.packages = with pkgs; [
    nix-index
    unzip
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
