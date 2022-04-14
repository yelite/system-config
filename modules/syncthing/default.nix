{ config, pkgs, lib, ... }:
let
  cfg = config.myHomeConfig.syncthing;
  inherit (lib) types mkIf mkEnableOption mkOption;
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
      tray.enable = true;
    };
  };
}
