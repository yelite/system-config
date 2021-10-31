{ pkgs, inputs, ... }:

{
  imports = [
    ./neovim
  ];

  home.packages = with pkgs; [
    nix-index
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
