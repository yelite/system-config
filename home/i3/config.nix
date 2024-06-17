{
  pkgs,
  cfg,
  ...
}: rec {
  fonts = {
    names = ["Overpass"];
    style = "Bold";
    size = 13.0;
  };
  gaps = {
    inner = 4;
    outer = 2;
    smartGaps = true;
    smartBorders = "no_gaps";
  };
  window = {
    titlebar = false;
  };
  bars = [
    {
      position = "top";
      statusCommand = "i3status-rs config-default.toml";
      fonts = {
        names = [
          "Roboto Mono"
        ];
        size = 9.0;
      };
      colors = {
        background = "#363a4f";

        focusedWorkspace = {
          background = "#8aadf4";
          border = "#8aadf4";
          text = "#24273a";
        };

        inactiveWorkspace = {
          background = "#1e2030";
          border = "#24273a";
          text = "#6e738d";
        };

        activeWorkspace = {
          background = "#1e2030";
          border = "#8aadf4";
          text = "#b8c0e0";
        };

        urgentWorkspace = {
          background = "#ee99a0";
          border = "#24273a";
          text = "#1e2030";
        };

        bindingMode = {
          background = "#eed49f";
          border = "#24273a";
          text = "#1e2030";
        };
      };
      extraConfig = ''
        bindsym button5 nop
        bindsym button4 nop
        workspace_min_width 60
      '';
    }
  ];

  terminal = "${pkgs.kitty}/bin/kitty";

  startup = [
    {
      command = "autorandr --change";
      always = false;
      notification = false;
    }
    {
      command = "${pkgs.i3-focus-last}/bin/i3-focus-last server";
      always = false;
      notification = false;
    }
    {
      command = "kitty -T i3#notes -d ~/notes -- nvim";
      always = false;
      notification = false;
    }
    {
      command = "kitty -T i3#scratchpad";
      always = false;
      notification = false;
    }
    {
      command = "supersonic";
      always = false;
      notification = false;
    }
    {
      command = "${pkgs.albert}/bin/albert";
      always = false;
      notification = false;
    }
  ];

  workspaceOutputAssign = let
    inherit (cfg) secondaryMonitorName;
  in [
    {
      workspace = "code1";
      output = "primary";
    }
    {
      workspace = "code2";
      output = "primary";
    }
    {
      workspace = "web";
      output = secondaryMonitorName;
    }
    {
      workspace = "q";
      output = secondaryMonitorName;
    }
    {
      workspace = "w";
      output = "primary";
    }
    {
      workspace = "e";
      output = secondaryMonitorName;
    }
  ];

  assigns = {};

  window.commands = [
    {
      # Needs floating enabled to correctly center on the screen
      command = "mark term; [con_mark=term] floating enable, resize set width 65 ppt height 75 ppt, border pixel 3, move position center, move scratchpad";
      criteria = {
        class = "kitty";
        title = "i3#scratchpad";
      };
    }
    {
      command = "mark notes; [con_mark=notes] floating enable, resize set width 42 ppt height 63 ppt, border pixel 3, move position center, move scratchpad";
      criteria = {
        class = "kitty";
        title = "i3#notes";
      };
    }
    {
      command = "mark music; [con_mark=music] floating enable, resize set width 75 ppt height 85 ppt, border pixel 1, move position center, move scratchpad";
      criteria = {class = "Supersonic";};
    }
    {
      command = "move position center";
      criteria = {
        window_role = "pop-up";
        class = "Vivaldi-stable";
      };
    }
    {
      command = "move position center";
      criteria = {
        class = "zoom";
        title = "Settings";
      };
    }
    {
      command = "move position center";
      criteria = {
        class = "zoom";
        title = "Participants.*";
      };
    }
    {
      command = "move position center";
      criteria = {
        class = "zoom";
        title = "Chat";
      };
    }
    {
      command = "border pixel 0, fullscreen enable global";
      criteria = {class = "flameshot";};
    }
  ];
  floating.criteria = [
    {window_role = "pop-up";}
    {
      class = "zoom";
      title = "Settings";
    }
    {
      class = "zoom";
      title = "Chat";
    }
    {
      class = "zoom";
      title = "Participants.*";
    }
  ];

  focus = {
    newWindow = "focus";
    followMouse = false;
    forceWrapping = false;
    mouseWarping = false;
  };

  modifier = "Mod1";
  keybindings = let
    mod = modifier;
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    rofi = "rofi";
    input-font-flag = ''-f "pango:Hack Nerd Font Mono 13"'';
  in {
    "${mod}+space" = "exec --no-startup-id ${pkgs.albert}/bin/albert toggle";
    "${mod}+Shift+Return" = "exec ${terminal}";

    "${mod}+h" = "focus left";
    "${mod}+j" = "focus down";
    "${mod}+k" = "focus up";
    "${mod}+l" = "focus right";
    "${mod}+o" = "focus output right";
    "${mod}+p" = "focus parent";
    "${mod}+t" = "focus mode_toggle";

    "${mod}+Shift+h" = "move left";
    "${mod}+Shift+j" = "move down";
    "${mod}+Shift+k" = "move up";
    "${mod}+Shift+l" = "move right";
    "${mod}+Shift+t" = "layout toggle splitv splith tabbed";
    "${mod}+Shift+m" = ''mode "Move Container"'';
    "${mod}+Shift+o" = "move container to output right; focus output right";
    "${mod}+Shift+p" = "move workspace to output right";

    "${mod}+semicolon" = ''exec --no-startup-id bash "${./swap_workspace.sh}" --stay'';
    "${mod}+Shift+semicolon" = ''exec --no-startup-id bash "${./swap_workspace.sh}"'';

    "${mod}+g" = ''exec ${rofi} -show window'';
    "${mod}+v" = ''exec i3-input ${input-font-flag} -F '[con_mark="%s"] focus' -l 1 -P "Goto: "'';
    "${mod}+Shift+v" = "exec i3-input ${input-font-flag} -F 'mark %s' -l 1 -P 'Mark: '";

    "${mod}+Shift+g" = "fullscreen toggle";
    "${mod}+Shift+slash" = "floating toggle";
    "${mod}+Shift+equal" = "move position center";
    "${mod}+Shift+x" = "kill";
    "${mod}+x" = ''exec --no-startup-id i3-input ${input-font-flag}'';

    "Mod4+Tab" = "exec --no-startup-id ${pkgs.i3-focus-last}/bin/i3-focus-last";
    "${mod}+Mod4+c" = ''exec ${rofi} -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}' '';

    "${mod}+a" = "workspace code2";
    "${mod}+s" = "workspace web";
    "${mod}+d" = "workspace code1";
    "${mod}+q" = "workspace q";
    "${mod}+w" = "workspace w";
    "${mod}+e" = "workspace e";
    "${mod}+r" = "workspace r";
    "${mod}+1" = ''[con_mark=term] scratchpad show'';
    "${mod}+2" = ''[con_mark=notes] scratchpad show'';
    "${mod}+3" = ''[con_mark=music] scratchpad show'';
    "${mod}+4" = ''[con_mark=any] scratchpad show'';
    "${mod}+Escape" = ''scratchpad show'';

    "${mod}+Shift+a" = "move container to workspace code2; workspace code2";
    "${mod}+Shift+s" = "move container to workspace web; workspace web";
    "${mod}+Shift+d" = "move container to workspace code1; workspace code1";
    "${mod}+Shift+q" = "move container to workspace q; workspace q";
    "${mod}+Shift+w" = "move container to workspace w; workspace w";
    "${mod}+Shift+e" = "move container to workspace e; workspace e";
    "${mod}+Shift+r" = "move container to workspace r; workspace r";
    "${mod}+Shift+1" = "mark term; move scratchpad; [con_mark=term] scratchpad show";
    "${mod}+Shift+2" = "mark notes; move scratchpad; [con_mark=notes] scratchpad show";
    "${mod}+Shift+3" = "mark music; move scratchpad; [con_mark=music] scratchpad show";
    "${mod}+Shift+4" = "mark any; move scratchpad; [con_mark=any] scratchpad show";

    "${mod}+Control+a" = "exec --no-startup-id bash ${./remote_open_workspace.sh} code2";
    "${mod}+Control+s" = "exec --no-startup-id bash ${./remote_open_workspace.sh} web";
    "${mod}+Control+d" = "exec --no-startup-id bash ${./remote_open_workspace.sh} code1";
    "${mod}+Control+q" = "exec --no-startup-id bash ${./remote_open_workspace.sh} q";
    "${mod}+Control+w" = "exec --no-startup-id bash ${./remote_open_workspace.sh} w";
    "${mod}+Control+e" = "exec --no-startup-id bash ${./remote_open_workspace.sh} e";
    "${mod}+Control+r" = "exec --no-startup-id bash ${./remote_open_workspace.sh} r";

    "XF86AudioMedia" = "[con_mark=music] scratchpad show";
    "XF86AudioPlay" = "exec --no-startup-id ${playerctl} play-pause";
    "XF86AudioForward" = "exec --no-startup-id ${playerctl} next";
    "XF86AudioNext" = "exec --no-startup-id ${playerctl} next";
    "XF86AudioPrev" = "exec --no-startup-id ${playerctl} previous";
    "XF86AudioRaiseVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_SINK@ 0.05+ -l 1";
    "XF86AudioLowerVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_SINK@ 0.05- -l 1";

    "${mod}+Control+Shift+1" = ''exec --no-startup-id "sleep 0.8; xset dpms force off"'';
    "${mod}+Control+Shift+2" = ''exec --no-startup-id "systemctl suspend"'';
    "XF86Sleep" = ''exec --no-startup-id "systemctl suspend"'';
    "${mod}+Control+Shift+3" = ''exec --no-startup-id "systemctl hibernate"'';
    "XF86PowerOff" = ''exec --no-startup-id "systemctl hibernate"'';

    "Shift+Mod4+4" = ''exec flameshot gui'';
    "Ctrl+Shift+Mod4+4" = ''exec flameshot gui -c'';

    "${mod}+Shift+z" = "restart";
    "${mod}+Shift+Escape" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
  };
  modes = let
    mod = modifier;
  in {
    "Move Container" = {
      "q" = "move container to workspace q; workspace q; mode default";
      "w" = "move container to workspace w; workspace w; mode default";
      "e" = "move container to workspace e; workspace e; mode default";
      "r" = "move container to workspace r; workspace r; mode default";
      "a" = "move container to workspace code2; workspace code2; mode default";
      "s" = "move container to workspace web; workspace web; mode default";
      "d" = "move container to workspace code1; workspace code1; mode default";
      "1" = ''mark term; move scratchpad; mode default'';
      "2" = ''mark notes; move scratchpad; mode default'';
      "3" = ''mark music; move scratchpad; mode default'';
      "4" = ''mark any; move scratchpad; mode default'';
      "Escape" = "mode default";
    };
    resize_and_move = {
      "h" = "resize shrink width 10 px or 10 ppt";
      "j" = "resize grow height 10 px or 10 ppt";
      "k" = "resize shrink height 10 px or 10 ppt";
      "l" = "resize grow width 10 px or 10 ppt";
      "Shift+h" = "move left";
      "Shift+j" = "move down";
      "Shift+k" = "move up";
      "Shift+l" = "move right";
      "Shift+o" = "move container to output next";
      "Shift+p" = "move workspace to output next";
      "Escape" = "mode default";
    };
    quick_focus = {};
    passthrough = {"${mod}+F12" = "mode default";};
  };
}
