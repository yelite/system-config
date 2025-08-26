{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.myConfig.desktop;
  inherit (lib) mkIf;
in
  mkIf (cfg.enable && cfg.xserver.enable) {
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
      theme = ../rofi-theme.rasi;
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
      enable = true;
      type = "fcitx5";
      fcitx5.addons = [
        (pkgs.fcitx5-rime.override
          {
            rimeDataPkgs = [
              pkgs.rime-data
              pkgs.rime-dict
              (pkgs.runCommandLocal "my-rime-config" {} ''
                mkdir -p $out/share/

                cp -r ${../rime} $out/share/rime-data
              '')
            ];
          })
      ];
    };

    # TODO: move all fcitx config into nix
    xdg.dataFile."fcitx5/themes/FluentDark-my" = {
      source = "${pkgs.fcitx5-fluent-dark}/share/fcitx5/themes/FluentDark-solid";
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

    xdg.configFile."greenclip.toml".source = ../greenclip.toml;
  }
