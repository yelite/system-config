{ pkgs, config, lib, ... }:
let
  cfg = config.myHomeConfig.display;
  inherit (lib) mkIf mkMerge mkEnableOption mkOption;
in
{
  options = {
    myHomeConfig.display = {
      enable = mkEnableOption "display1";
      highDPI = mkEnableOption "highDPI";
      displayProfiles = mkOption {
        type = with lib.types; attrsOf (uniq anything);
        description = "Autorandr profiles specification.";
        default = { };
      };

      xserver = {
        enable = mkEnableOption "xserver";
      };

      wayland = {
        enable = mkEnableOption "wayland";
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable && cfg.wayland.enable)
      {
        home.packages = with pkgs; [
          wev
          wl-clipboard
          cliphist
          wofi
        ];

        wayland.windowManager.hyprland = {
          enable = true;
          enableNvidiaPatches = true;
        } // (import ./hyprland.nix {
          inherit pkgs lib;
        });

        programs = {
          eww-hyprland = {
            enable = true;
          };
        };

        services = {
          gammastep = {
            enable = true;
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
                { criteria = "HDMI-A-3"; scale = 2.0; position = "0,445"; }
                { criteria = "HDMI-A-1"; scale = 2.0; position = "1920,0"; }
              ];
            };
          };
        };
      })
    (mkIf (cfg.enable && cfg.xserver.enable)
      {
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

        home.packages = with pkgs; [
          xclip
          xdotool
          xdragon
          xorg.xev
          xorg.xmodmap
        ];

        programs.autorandr = {
          enable = true;
          profiles = cfg.displayProfiles;
        };

        xsession = {
          enable = true;
          initExtra = ''
            ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
          '';
          scriptPath = ".xsession-hm";
        };

        home.pointerCursor = {
          x11.enable = true;
          package = pkgs.apple-cursor;
          name = "macOSMonterey";
          size = 40;
        };
      })
    (mkIf (cfg.enable && cfg.highDPI)
      {
        xresources.properties = {
          "Xft.dpi" = 192;
        };
        home.sessionVariables = {
          GDK_SCALE = "2";
          GDK_DPI_SCALE = "0.5";
          QT_AUTO_SCREEN_SET_FACTOR = "0";
          QT_SCALE_FACTOR = "2";
          QT_FONT_DPI = "96";
        };
      })
  ];
}
