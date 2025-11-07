{
  lib,
  config,
  hostPlatform,
  ...
}: let
  cfg = config.myConfig;
  inherit (lib) mkEnableOption mkOption types;
  mointorOptionType = types.submodule {
    options = {
      id = mkOption {
        type = types.str;
        default = "1";
        description = "Display number according to ddcutil.";
      };
      localSource = mkOption {
        type = types.str;
        default = "17";
      };
      remoteSource = mkOption {
        type = types.str;
        default = "1";
      };
    };
  };
in {
  options.myConfig = {
    username = mkOption {
      type = types.str;
      default = "liteye";
    };

    configDirectory = mkOption {
      type = types.str;
      default = "$HOME/.system-config";
    };

    publicConfigDirectory = mkOption {
      type = types.str;
      default = "$HOME/.system-config/public";
    };

    isServer = mkEnableOption "isServer";

    desktop = {
      enable = mkEnableOption "desktop";

      displayProfiles = mkOption {
        type = with types; attrsOf (uniq anything);
        description = "Autorandr profiles specification.";
        default = {};
      };
      monitors = mkOption {
        type = types.submodule {
          options = {
            primary = mkOption {
              type = types.nullOr mointorOptionType;
              default = null;
            };
            secondary = mkOption {
              type = types.nullOr mointorOptionType;
              default = null;
            };
          };
        };
        description = "Autorandr profiles specification.";
        default = {};
      };
      highDPI = mkEnableOption "highDPI";

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
    shpool.enable = mkEnableOption "shpool" // {default = cfg.isServer;};

    uinputGroup.enable = mkEnableOption "uinput group";
  };

  config = {
    assertions = let
      onlyOnDesktop = name: {
        assertion = !cfg.${name}.enable || (cfg.desktop.enable || hostPlatform.isDarwin);
        message = "${name} can only be enabled if desktop is enabled or it's on MacOS.";
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
