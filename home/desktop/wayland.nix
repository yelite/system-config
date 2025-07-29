{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.myConfig.desktop;
  inherit (lib) mkIf;
in
  mkIf (cfg.enable && cfg.wayland.enable) {
    home.packages = with pkgs; [
      wev
      wl-clipboard
      cliphist
      wofi
    ];

    services = {
      gammastep = {
        enable = true;
        provider = "geoclue2";

        temperature = {
          night = 5200;
          day = 6500;
        };
      };
    };
  }
