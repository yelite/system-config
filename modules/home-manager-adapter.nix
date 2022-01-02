{ lib, config, ... }:
let
  types = lib.types;
  cfg = config.myConfig;
in
{
  options.myConfig = {
    username = lib.mkOption {
      type = types.str;
      default = "liteye";
    };
    # Type is copied from https://github.com/nix-community/home-manager/pull/2396
    homeManagerModules = lib.mkOption {
      type = with types;
        listOf (mkOptionType {
          name = "submodule";
          inherit (submodule { }) check;
          merge = lib.options.mergeOneOption;
          description = "Home Manager Modules";
        });
    };
  };

  config = {
    home-manager.users.${cfg.username} = { };
    home-manager.sharedModules = cfg.homeManagerModules;
  };
}
