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

    wayland.windowManager.hyprland =
      {
        enable = true;
      }
      // (import ../hyprland.nix {
        inherit pkgs lib;
      });

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
      kanshi = {
        enable = true;
        systemdTarget = "hyprland-session.target";
        profiles = {
          "regular".outputs = [
            {
              criteria = "HDMI-A-3";
              scale = 2.0;
              position = "0,445";
            }
            {
              criteria = "HDMI-A-1";
              scale = 2.0;
              position = "1920,0";
            }
          ];
        };
      };
    };
  }
