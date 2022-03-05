{ pkgs, config, lib, ... }:
let
  cfg = config.myConfig.xserver;
  inherit (lib) mkIf mkEnableOption mkOption;
in
{
  imports = [
    ./greetd.nix
  ];

  options = {
    myConfig.xserver = {
      enable = mkEnableOption "xserver";
      highDPI = mkEnableOption "highDPI";
      displayProfiles = mkOption {
        type = with lib.types; attrsOf (uniq anything);
        description = "Autorandr profiles specification.";
        default = { };
      };
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      fonts = with pkgs;
        [
          material-design-icons

          merriweather
          source-han-sans
          source-han-serif
          source-han-mono
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          overpass

          (nerdfonts.override {
            fonts = [ "Hack" ];
          })
        ];

      enableDefaultFonts = false;

      fontconfig.defaultFonts = {
        serif = [ "Noto Serif" "Noto Sans CJK SC" "Noto Sans Symbols" "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" "Noto Sans Symbols" "Noto Color Emoji" ];
        monospace = [ "Hack Nerd Font Mono" "Noto Sans Symbols" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };

    services = {
      geoclue2.enable = true;

      xserver = {
        enable = true;

        libinput = {
          enable = true;
          mouse.accelProfile = "flat";
          mouse.middleEmulation = false;
        };
        wacom.enable = true;
      };
    };

    myConfig.homeManagerModules = [{
      imports = [ ./home.nix ];
      config = {
        myHomeConfig.xserver = cfg;
      };
    }];
  };
}
