{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.nvfancontrol;
in
  lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.nvfancontrol
    ];

    environment.etc = {
      "xdg/nvfancontrol.conf".source = ./nvfancontrol.toml;
    };
  }
