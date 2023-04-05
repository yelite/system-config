{ config, pkgs, lib, hostPlatform, ... }:
let
  cfg = config.myConfig.nvfancontrol;
  inherit (lib) mkIf mkEnableOption;
in
lib.optionalAttrs hostPlatform.isLinux {
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
