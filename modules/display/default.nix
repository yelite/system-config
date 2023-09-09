{ pkgs, config, lib, hostPlatform, ... }:
let
  cfg = config.myConfig.display;
  inherit (lib) mkIf mkEnableOption mkOption;
in
lib.optionalAttrs hostPlatform.isLinux {
  imports = [
    ./greetd.nix
  ];

  options = {
    myConfig.display = {
      enable = mkEnableOption "display";
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

  config = mkIf cfg.enable {
    myConfig.homeManagerModules = [{
      imports = [ ./home.nix ];
      config = {
        myHomeConfig.display = cfg;
      };
    }];

    fonts = {
      packages = with pkgs;
        [
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
            fonts = [ "Hack" ];
          })
        ];

      enableDefaultPackages = false;

      fontconfig.subpixel = mkIf cfg.highDPI {
        rgba = "none";
        lcdfilter = "none";
      };

      fontconfig.defaultFonts = {
        serif = [ "Noto Serif" "Noto Sans CJK SC" "Noto Sans Symbols" "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" "Noto Sans Symbols" "Noto Color Emoji" ];
        monospace = [ "Hack Nerd Font Mono" "Noto Sans Symbols" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
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

      xserver = mkIf cfg.xserver.enable {
        enable = true;
        libinput = {
          enable = true;
          mouse.accelProfile = "flat";
          mouse.middleEmulation = false;
        };
        wacom.enable = true;
      };
    };

    xdg.portal = {
      enable = true;
    };

    # TODO: for kde connect, move this to other place
    programs.kdeconnect = {
      enable = true;
    };

    environment.etc = {
      "pipewire/pipewire.conf.d/99-my-device.conf".text = ''
        context.properties = {
          default.clock.rate = 44100
          default.clock.allowed-rates = [ 44100 48000 88200 96000 176400 192000 352800 384000 ]
        }
      '';
    };
  };
}
