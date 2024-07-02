{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkOptionType types;
  cfg = config.myConfig;
in {
  options.myConfig = {
    username = mkOption {
      type = types.str;
      default = "liteye";
    };
    home = mkOption {
      type = mkOptionType {
        name = "home";
        inherit (types.submodule {}) check;
        merge = lib.options.mergeOneOption;
        description = "My Home Manager Config";
      };
      default = {};
    };
    # Type is copied from https://github.com/nix-community/home-manager/pull/2396
    hmModules = mkOption {
      type = with types;
        listOf (mkOptionType {
          name = "submodule";
          inherit (submodule {}) check;
          merge = lib.options.mergeOneOption;
          description = "Extra Home Manager Modules";
        });
      default = [];
    };
  };

  config = {
    home-manager = {
      users.${cfg.username} = {};
      sharedModules =
        cfg.hmModules
        ++ [
          {
            myHomeConfig = cfg.home;
          }
        ];
    };
  };
}
