{ config, lib, systemInfo, ... }:

with lib;

optionalAttrs systemInfo.isDarwin {
  config = {
    system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = "-1";
  };
}
