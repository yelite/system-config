{
  pkgs,
  config,
  ...
}: let
  cfg = config.myConfig.desktop;
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  main-display = "ViewSonic Corporation VP3268a-4K WHU212900173";
  side-display = "Lenovo Group Limited LEN T32p-20 VNA4WK30";
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
          accel-speed = -0.62;
          accel-profile = "flat";
        };
        focus-follows-mouse = {
          enable = false;
        };
        mod-key = "Alt";
        mod-key-nested = "Super";
      };

      cursor.hide-when-typing = true;

      outputs = {
        "${main-display}" = {
          scale = 2.0;
          position = {
            x = 0;
            y = 445;
          };
          focus-at-startup = true;
        };
        "${side-display}" = {
          scale = 2.0;
          position = {
            x = 1920;
            y = 0;
          };
        };
      };

      clipboard.disable-primary = true;

      layout = {
        gaps = 0;
        center-focused-column = "never";
        preset-column-widths = [
          {proportion = 0.382;}
          {proportion = 0.5;}
          {proportion = 0.618;}
        ];
        default-column-width = {proportion = 0.5;};
        focus-ring = {
          enable = false;
        };
        border = {
          enable = true;
          width = 2;
          inactive.color = "#434c5e";
          active.color = "#81a1c1";
          urgent.color = "#d08770";
        };
      };

      prefer-no-csd = true;

      spawn-at-startup = [
        {command = ["${pkgs.albert}/bin/albert"];}
        # {command = ["wl-paste" "--type" "text" "--watch" "cliphist" "store"];}
        # {command = ["wl-paste" "--type" "image" "--watch" "cliphist" "store"];}
        # {command = ["kitty"];}
      ];

      workspaces = {
        code = {
          open-on-output = main-display;
        };
        code2 = {
          open-on-output = side-display;
        };
        web = {
          open-on-output = side-display;
        };
        o1 = {
          open-on-output = main-display;
        };
        o2 = {
          open-on-output = side-display;
        };
      };

      window-rules = [
        {
          matches = [
            {
              app-id = "firefox-devedition";
            }
            {
              app-id = "kitty";
              at-startup = true;
            }
          ];
          open-maximized = true;
        }
        {
          matches = [
            {
              title = "Albert";
              app-id = "";
            }
          ];
          border = {
            enable = false;
          };
        }
      ];

      binds = with config.lib.niri.actions; {
        "Mod+Shift+Return".action = spawn "${pkgs.kitty}/bin/kitty";
        "Mod+R".action = toggle-overview;

        "Mod+A".action = focus-workspace "code2";
        "Mod+S".action = focus-workspace "web";
        "Mod+D".action = focus-workspace "code";
        "Mod+Q".action = focus-workspace "o1";
        "Mod+W".action = focus-workspace "o2";

        "Shift+Mod+A".action.move-window-to-workspace = "code2";
        "Shift+Mod+S".action.move-window-to-workspace = "web";
        "Shift+Mod+D".action.move-window-to-workspace = "code";
        "Shift+Mod+Q".action.move-window-to-workspace = "o1";
        "Shift+Mod+W".action.move-window-to-workspace = "o2";

        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;
        "Mod+O".action = focus-monitor-next;
        "Super+Tab".action = focus-window-previous;
        "Shift+Super+Tab".action = focus-workspace-previous;
        "Mod+T".action = center-column;
        "Mod+V".action = switch-preset-column-width;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+J".action = move-window-down;
        "Mod+Shift+K".action = move-window-up;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+O".action = move-column-to-monitor-next;
        "Mod+Shift+P".action = move-workspace-to-monitor-next;
        "Mod+Shift+T".action = toggle-column-tabbed-display;
        "Mod+Shift+V".action = maximize-column;

        "Mod+Space".action.spawn = ["${pkgs.wofi}/bin/wofi" "--show" "drun"];
        "Mod+Super+C".action.spawn = ["sh" "-c" "cliphist list | wofi --dmenu | cliphist decode | wl-copy"];

        "Mod+Shift+X".action = close-window;
        "Mod+Slash".action = switch-focus-between-floating-and-tiling;
        "Mod+Shift+Slash".action.toggle-window-floating = {};
        "Mod+Shift+F".action.fullscreen-window = {};
        "Mod+Shift+G".action.toggle-windowed-fullscreen = {};

        "Ctrl+Shift+Super+4".action = screenshot-window {write-to-disk = false;};
        "Ctrl+Shift+Super+5".action = screenshot {show-pointer = false;};

        "XF86AudioPlay" = {
          action = spawn "${playerctl}" "play-pause";
          allow-when-locked = true;
        };
        "XF86AudioNext" = {
          action = spawn "${playerctl}" "next";
          allow-when-locked = true;
        };
        "XF86AudioPrev" = {
          action = spawn "${playerctl}" "previous";
          allow-when-locked = true;
        };

        "Mod+Shift+Control+1" = {
          action = power-off-monitors;
        };
        "Mod+Shift+Control+2" = {
          action = spawn "systemctl" "suspend";
          allow-when-locked = true;
        };
        "Mod+Shift+Control+3" = {
          action = spawn "systemctl" "hibernate";
          allow-when-locked = true;
        };
      };
    };
  };
}
