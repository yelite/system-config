{ config, pkgs, lib, inputs, ... }:
let
  cfg = config.myHomeConfig.i3;
  inherit (lib) types mkIf mkEnableOption mkOption;
in
{
  options = {
    myHomeConfig.i3 = {
      enable = mkEnableOption "i3";

      secondaryMonitorName = mkOption {
        type = types.str;
        default = "primary";
      };
    };
  };

  config = mkIf cfg.enable {
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = import ./config.nix { inherit cfg pkgs; };
      extraConfig = ''
      '';
    };
  };
}
