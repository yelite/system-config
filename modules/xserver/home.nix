{ pkgs, config, lib, ... }:
let
  cfg = config.myHomeConfig.xserver;
  inherit (lib) mkIf mkMerge mkEnableOption mkOption types;
in
{
  options = {
    myHomeConfig.xserver = {
      enable = mkEnableOption "xserver";
      highDPI = mkEnableOption "highDPI";
      displayProfiles = mkOption {
        type = with types; attrsOf (uniq anything);
        description = "Autorandr profiles specification.";
        default = { };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable
      {
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
