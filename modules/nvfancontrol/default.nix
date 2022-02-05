{ config, pkgs, lib, ... }:
let
  cfg = config.myConfig.nvfancontrol;
  inherit (lib) mkIf mkEnableOption;
in
{
  options =
    {
      myConfig.nvfancontrol = {
        enable = mkEnableOption "nvfancontrol";
      };
    };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.nvfancontrol
    ];

    environment.etc = {
      "xdg/nvfancontrol.conf".source = ./nvfancontrol.toml;
    };

    services.xserver = {
      deviceSection = ''
        Option     "Coolbits" "4"
      '';
    };
  };
}
