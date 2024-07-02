{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.myConfig.display;
  inherit (lib) mkIf mkEnableOption mkOption mkMerge;
in {
  options = {
    myConfig.display = {
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
    {
      home-manager.sharedModules = [
        ./home.nix
        {
          myHomeConfig.display = cfg;
        }
      ];
    }
    (mkIf cfg.enable {
      fonts = {
        packages = with pkgs; [
          material-design-icons
          material-symbols

          lexend
          merriweather
          source-han-sans
          source-han-serif
          source-han-mono
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          roboto-mono
          overpass

          (nerdfonts.override {
            fonts = ["Hack"];
          })
        ];

        enableDefaultPackages = false;

        fontconfig.subpixel = mkIf cfg.highDPI {
          rgba = "none";
          lcdfilter = "none";
        };

        fontconfig.defaultFonts = {
          serif = ["Noto Serif" "Noto Sans CJK SC" "Noto Sans Symbols" "Noto Color Emoji"];
          sansSerif = ["Noto Sans" "Noto Sans CJK SC" "Noto Sans Symbols" "Noto Color Emoji"];
          monospace = ["Hack Nerd Font Mono" "Noto Sans Symbols" "Noto Color Emoji"];
          emoji = ["Noto Color Emoji"];
        };
      };

      services = {
        geoclue2.enable = true;
        ddccontrol.enable = true;

        pipewire = {
          enable = true;
          wireplumber.enable = true;
          pulse.enable = true;
          alsa.enable = true;
          jack.enable = true;
        };

        gnome.gnome-keyring = {
          enable = true;
        };

        xserver = mkIf cfg.xserver.enable {
          enable = true;
          displayManager = {
            startx.enable = true;
          };
          wacom.enable = true;
        };

        libinput = {
          enable = true;
          mouse.accelProfile = "flat";
          mouse.middleEmulation = false;
        };

        greetd = {
          enable = true;
          vt = 2; # To avoid kernel logging. See https://github.com/apognu/tuigreet/issues/17
          settings = {
            default_session = {
              command = lib.concatStringsSep " " [
                "${pkgs.greetd.tuigreet}/bin/tuigreet"
                "--asterisks"
                "--remember"
                ''--cmd "systemd-cat -t i3 startx ~/.xsession-hm"''
              ];
            };
          };
        };
      };

      programs = {
        seahorse.enable = true;
      };

      security.pam.services.greetd.enableGnomeKeyring = true;

      # To avoid kernel logging on greetd tty. See https://github.com/apognu/tuigreet/issues/17
      boot.kernelParams = ["console=tty1"];

      xdg.portal = {
        enable = true;
        # This is added based on the warning message from the new xdg portal impl
        # TODO: figure out how to configure this properly
        config.common.default = "*";
      };

      # TODO: for kde connect, move this to other place
      programs.kdeconnect = {
        enable = true;
      };
    })
  ];
}
