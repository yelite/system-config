{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.myConfig = {
    isServer = mkEnableOption "isServer";
  };

  config = {
    home-manager.sharedModules = [
      {
        options.myHomeConfig.isServer = mkEnableOption "isServer";
        config.myHomeConfig.isServer = lib.mkDefault config.myConfig.isServer;
      }
    ];
  };
}
