{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.myHomeConfig.display;
  inherit (lib) mkIf mkMerge mkEnableOption mkOption;
in {
  options = {
    myHomeConfig.display = {
      enable = mkEnableOption "display";
      highDPI = mkEnableOption "highDPI";
      displayProfiles = mkOption {
        type = with lib.types; attrsOf (uniq anything);
        description = "Autorandr profiles specification.";
        default = {};
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
    (mkIf cfg.enable {
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.apple-cursor;
        name = "macOSMonterey";
        size = 48;
      };
    })
    (mkIf (cfg.enable && cfg.wayland.enable)
      {
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
          // (import ./hyprland.nix {
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
          haskellPackages.greenclip
        ];

        programs.autorandr = {
          enable = true;
          profiles = cfg.displayProfiles;
        };

        programs.rofi = {
          enable = true;
          theme = ./rofi-theme.rasi;
          plugins = [
            pkgs.rofi-calc
            pkgs.rofi-emoji
          ];
          extraConfig = {
            # TODO: expose these through shortcuts
            modi = "combi,emoji,calc,drun,window";
            dpi = 1;
          };
        };

        i18n.inputMethod = {
          enabled = "fcitx5";
          fcitx5.addons = [
            (pkgs.fcitx5-rime.override
              {
                rimeDataPkgs = [
                  pkgs.rime-data
                  pkgs.rime-dict
                  (pkgs.runCommandLocal "my-rime-config" {} ''
                    mkdir -p $out/share/

                    cp -r ${./rime} $out/share/rime-data
                  '')
                ];
              })
          ];
        };

        # TODO: move all fcitx config into nix
        xdg.dataFile."fcitx5/themes/FluentDark-my" = {
          source = "${pkgs.fcitx5-fluent-dark}/share/fcitx5/themes/FluentDark";
        };

        xsession = {
          enable = true;
          initExtra = ''
            ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
            ${pkgs.xorg.xset}/bin/xset s off
            ${pkgs.xorg.xset}/bin/xset s noblank
            ${pkgs.xorg.xset}/bin/xset -dpms
          '';
          scriptPath = ".xsession-hm";
        };

        # TODO: split this to standalone file
        systemd.user.services.greenclip = {
          Unit = {
            Description = "greenclip";
            PartOf = ["hm-graphical-session.target"];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon";
          };
          Install = {
            WantedBy = ["hm-graphical-session.target"];
          };
        };

        xdg.configFile."greenclip.toml".source = ./greenclip.toml;
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
