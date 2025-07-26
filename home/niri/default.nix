{
  pkgs,
  config,
  ...
}: let
  cfg = config.myConfig.desktop;
  playerctl = "${pkgs.playerctl}/bin/playerctl";
in {
  programs.niri = {
    enable = cfg.wayland.enable;
    package = pkgs.niri;
    settings = {
      input = {
        keyboard.xkb = {
          layout = "us";
        };
        mouse = {
          accel-speed = -0.4;
          accel-profile = "flat";
        };
        focus-follows-mouse = {
          enable = false;
        };
      };

      outputs = {
        "HDMI-A-3" = {
          scale = 2.0;
          position = {
            x = 0;
            y = 445;
          };
        };
        "HDMI-A-1" = {
          scale = 2.0;
          position = {
            x = 1920;
            y = 0;
          };
        };
      };

      layout = {
        gaps = 5;
        center-focused-column = "never";
        preset-column-widths = [
          {proportion = 1.0 / 3.0;}
          {proportion = 0.5;}
          {proportion = 2.0 / 3.0;}
        ];
        default-column-width = {proportion = 0.5;};
        focus-ring = {
          enable = true;
          width = 2;
          active.color = "#7fc8ff";
          inactive.color = "#505050";
        };
        border = {
          enable = true;
          width = 1;
          active.color = "#ffc87f";
          inactive.color = "#505050";
        };
      };

      prefer-no-csd = true;

      spawn-at-startup = [
        # {command = ["eww" "open" "bar"];}
        # {command = ["wl-paste" "--type" "text" "--watch" "cliphist" "store"];}
        # {command = ["wl-paste" "--type" "image" "--watch" "cliphist" "store"];}
        # {command = ["kitty"];}
      ];

      binds = with pkgs; {
        "Alt+Shift+Return".action.spawn = ["${kitty}/bin/kitty"];
        "Alt+Shift+X".action.close-window = {};

        "Alt+H".action.focus-column-left = {};
        "Alt+J".action.focus-window-down = {};
        "Alt+K".action.focus-window-up = {};
        "Alt+L".action.focus-column-right = {};

        "Alt+Shift+H".action.move-column-left = {};
        "Alt+Shift+J".action.move-window-down = {};
        "Alt+Shift+K".action.move-window-up = {};
        "Alt+Shift+L".action.move-column-right = {};

        "Alt+Q".action.focus-workspace = 1;
        "Alt+W".action.focus-workspace = 2;
        "Alt+E".action.focus-workspace = 3;

        "Alt+Shift+Q".action.move-window-to-workspace = 1;
        "Alt+Shift+W".action.move-window-to-workspace = 2;
        "Alt+Shift+E".action.move-window-to-workspace = 3;

        "Alt+Space".action.spawn = ["${wofi}/bin/wofi" "--show" "drun"];
        "Alt+Shift+C".action.spawn = ["sh" "-c" "cliphist list | wofi --dmenu | cliphist decode | wl-copy"];

        "Alt+Shift+Slash".action.toggle-window-floating = {};
        "Alt+Shift+G".action.fullscreen-window = {};

        "XF86AudioPlay".action.spawn = ["${playerctl}" "play-pause"];
        "XF86AudioNext".action.spawn = ["${playerctl}" "next"];
        "XF86AudioPrev".action.spawn = ["${playerctl}" "previous"];
      };
    };
  };
}
