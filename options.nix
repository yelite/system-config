{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.myConfig = {
    username = mkOption {
      type = types.str;
      default = "liteye";
    };

    isServer = mkEnableOption "isServer";

    desktop = {
      enable = mkEnableOption "desktop";

      displayProfiles = mkOption {
        type = with types; attrsOf (uniq anything);
        description = "Autorandr profiles specification.";
        default = {};
      };
      highDPI = mkEnableOption "highDPI";

      xserver = {
        enable = mkOption {
          default = true;
          example = false;
          description = "Whether to enable xserver.";
          type = types.bool;
        };
      };

      wayland = {
        enable = mkEnableOption "wayland";
      };

      keyboardRemap.enable = mkEnableOption "keyboardRemap";
      logitech = {
        enable = mkEnableOption "logitech";
        configFile = mkOption {
          type = types.path;
        };
      };
    };

    nfs-client.enable = lib.mkEnableOption "Enable NFS client support";
    nvfancontrol.enable = mkEnableOption "nvfancontrol";
    syncthing.enable = mkEnableOption "syncthing";
    neovim.enable = mkEnableOption "neovim";
    kitty.enable = mkEnableOption "kitty";
    fish.enable = mkEnableOption "fish";
    firefox.enable = mkEnableOption "firefox";
    dunst.enable = mkEnableOption "dunst";
    i3 = {
      enable = mkEnableOption "i3";

      secondaryMonitorName = mkOption {
        type = types.str;
        default = "primary";
      };
    };

    uinputGroup.enable = mkEnableOption "uinput group";
  };
}
