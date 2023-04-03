{ lib, config, hostPlatform, inputs, ... }:
let
  inherit (lib) mkOption mkOptionType types;
  cfg = config.myConfig;
in
{
  options.myConfig = {
    username = mkOption {
      type = types.str;
      default = "liteye";
    };
    homeManagerConfig = mkOption {
      type = mkOptionType {
        name = "homeManagerConfig";
        inherit (types.submodule { }) check;
        merge = lib.options.mergeOneOption;
        description = "My Home Manager Config";
      };
      default = { };
    };
    # Type is copied from https://github.com/nix-community/home-manager/pull/2396
    homeManagerModules = mkOption {
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
    home-manager = {
      users.${cfg.username} = { };
      sharedModules = cfg.homeManagerModules ++ [{
        myHomeConfig = cfg.homeManagerConfig;
        # https://github.com/nix-community/home-manager/issues/3047
        home.stateVersion = "18.09";
      }];
      useGlobalPkgs = true;
      extraSpecialArgs = {
        inherit inputs hostPlatform;
      };
    };
  };
}
