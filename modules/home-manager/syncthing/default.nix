{ config, lib, hostPlatform, ... }:
let
  cfg = config.myHomeConfig.syncthing;
  inherit (lib) mkIf mkEnableOption;
in
{
  options = {
    myHomeConfig.syncthing = {
      enable = mkEnableOption "syncthing";
    };
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray = {
        enable = hostPlatform.isLinux;
        command = "syncthingtray --wait";
      };
    };
  };
}
