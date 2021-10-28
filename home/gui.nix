{ pkgs, inputs, ... }:

{
  imports = [
    ./cli.nix
  ];

  home.packages = with pkgs; [
    zeal
    neovide
    realvnc-vnc-viewer

    xclip
    xdotool
    xdragon
  ];

  programs.alacritty.enable = true;

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

  xsession = {
    enable = true;
    # to be able to use system-configured sessions alongside HM ones
    scriptPath = ".xsession-hm";

    pointerCursor = {
      package = pkgs.quintom-cursor-theme;
      name = "Quintom_Ink";
      size = 24;
    };

    preferStatusNotifierItems = true;

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };
}
