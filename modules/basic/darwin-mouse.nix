{ config, lib, systemInfo, ... }:

with lib;

optionalAttrs systemInfo.isDarwin {
  options = {
    system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" =
      mkOption {
        type = types.nullOr (types.string);
        default = null;
        description = ''
          Mouse acceleration factor. -1 to disable
        '';
      };
  };

  config = {
    system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = "-1";
  };
}
