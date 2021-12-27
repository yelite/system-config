{ pkgs, inputs, ... }:
{
  imports = [
    ./cli.nix
    ./modules/i3.nix
  ];

  home.packages = with pkgs; [
    zeal
    neovide
    realvnc-vnc-viewer

    xclip
    xdotool
    xdragon
  ];

  services = {
    redshift = {
      enable = true;
      provider = "geoclue2";

      temperature = {
        night = 4500;
        day = 6500;
      };
    };

  };
}
