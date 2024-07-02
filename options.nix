{
  lib,
  config,
  ...
}: let
  cfg = config.myConfig;
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

      i3 = {
        enable = mkEnableOption "i3";

        secondaryMonitorName = mkOption {
          type = types.str;
          default = "primary";
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

    dunst.enable = mkEnableOption "dunst" // {default = cfg.desktop.enable;};
    firefox.enable = mkEnableOption "firefox";
    fish.enable = mkEnableOption "fish";
    kitty.enable = mkEnableOption "kitty";
    neovim.enable = mkEnableOption "neovim";
    nfs-client.enable = mkEnableOption "Enable NFS client support";
    nvfancontrol.enable = mkEnableOption "nvfancontrol";
    syncthing.enable = mkEnableOption "syncthing";

    uinputGroup.enable = mkEnableOption "uinput group";
  };

  config = {
    assertions = let
      onlyOnDesktop = name: {
        assertion = !cfg.${name}.enable || cfg.desktop.enable;
        message = "${name} can only be enabled if desktop is enabled.";
      };
    in [
      {
        assertion = !(cfg.isServer && cfg.desktop.enable);
        message = "isServer and desktop.enable cannot be both true.";
      }
      (onlyOnDesktop "kitty")
      (onlyOnDesktop "firefox")
      (onlyOnDesktop "dunst")
    ];
  };
}
