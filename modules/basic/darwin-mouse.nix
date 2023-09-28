{
  config,
  lib,
  hostPlatform,
  ...
}:
with lib;
  optionalAttrs hostPlatform.isDarwin {
    config = {
      system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = "-1";
    };
  }
