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
        # TODO: Enable after nvidia driver support GAMMA_LUT
        enable = false;
        provider = "geoclue2";

        temperature = {
          night = 4500;
          day = 6500;
        };
      };
    };
  }
