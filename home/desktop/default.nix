{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.myConfig.desktop;
  inherit (lib) mkIf;
in {
  imports = [
    ./wayland.nix
    ./xserver.nix
    ./toggle-source.nix
    inputs.niri.homeModules.niri
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      albert
    ];
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.apple-cursor;
      name = "macOSMonterey";
      size = 48;
    };
    xresources.properties = mkIf cfg.highDPI {
      "Xft.dpi" = 192;
    };
    home.sessionVariables = mkIf cfg.highDPI {
      # GDK_SCALE = "2";
      # GDK_DPI_SCALE = "0.5";
      # QT_AUTO_SCREEN_SET_FACTOR = "0";
      # QT_SCALE_FACTOR = "2";
      # QT_FONT_DPI = "96";
    };
  };
}
