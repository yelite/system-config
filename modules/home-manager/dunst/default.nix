{ config, lib, ... }:
let
  cfg = config.myHomeConfig.dunst;
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
          width = 325;
          height = 250;
          frame_width = 2;
          corner_radius = 5;
          offset = "20x45";
          font = "Hack Nerd Font Mono 9";
          markup = "full";
          frame_color = "#eeffff";
          separator_color = "#eeffff";
        };

        low = {
          msg_urgency = "low";
          background = "#8796B0";
          foreground = "#eeffff";
          highlight = "#676E95";
        };

        normal = {
          msg_urgency = "normal";
          background = "#676E95";
          foreground = "#eeffff";
          highlight = "#C792EA";
        };

        critical = {
          msg_urgency = "critical";
          background = "#F07178";
          foreground = "#FFFFFF";
          highlight = "#FF4360";
        };
      };
    };
  };
}
