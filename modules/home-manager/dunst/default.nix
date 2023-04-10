{ config, lib, ... }:
let cfg = config.myHomeConfig.dunst;
  inherit (lib) mkIf mkEnableOption;
in
{
  options = {
    myHomeConfig.dunst = {
      enable = mkEnableOption "dunst";
    };
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          follow = "keyboard";
          width = "(100, 400)";

        };
      };
    };
  };
}
