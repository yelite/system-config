{ pkgs, cfg, ... }:
rec {
  fonts = {
    names = [ "Overpass" ];
    style = "Bold";
    size = 13.0;
  };
  gaps = {
    inner = 4;
    outer = 2;
    smartGaps = true;
    smartBorders = "no_gaps";
  };
  bars = [{
    position = "top";
    statusCommand = "${pkgs.i3status}/bin/i3status";
  }];

  terminal = "${pkgs.kitty}/bin/kitty";
  menu = "${pkgs.rofi}/bin/rofi -show run";

  startup = [
    {
      command = "autorandr --change";
      always = true;
      notification = false;
    }
  ];

  workspaceOutputAssign = let inherit (cfg) secondaryMonitorName; in
    [
      {
        workspace = "1: Web 2";
        output = secondaryMonitorName;
      }
      {
        workspace = "2: Terminal";
        output = secondaryMonitorName;
      }
      {
        workspace = "3: Communication";
        output = secondaryMonitorName;
      }
      {
        workspace = "4: Others";
        output = secondaryMonitorName;
      }
      {
        workspace = "6: Web 1";
        output = "primary";
      }
      {
        workspace = "7: Code 1";
        output = "primary";
      }
      {
        workspace = "8: Code 2";
        output = "primary";
      }
      {
        workspace = "10: Others";
        output = "primary";
      }
    ];

  assigns = { };

  window.commands = [ ];
  floating.criteria = [ ];

  focus = {
    followMouse = false;
    forceWrapping = false;
    mouseWarping = false;
  };

  modifier = "Mod1";
  keybindings =
    let mod = modifier;
    in
    {
      "${mod}+space" = "exec ${menu}";

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
      "${mod}+Shift+o" = "move container to output next";
      "${mod}+Shift+p" = "move workspace to output next";

      "${mod}+Shift+Return" = "exec ${terminal}";
      "${mod}+Shift+g" = "fullscreen toggle";
      "${mod}+Shift+`" = "floating toggle";
      "${mod}+Shift+x" = "kill";

      "${mod}+a" = "workspace Web 1";
      "${mod}+s" = "workspace Code 2";
      "${mod}+d" = "workspace Code 1";
      "${mod}+f" = "workspace Web 2";
      "${mod}+q" = "workspace \"4: Others\"";
      "${mod}+w" = "workspace Terminal";
      "${mod}+e" = "workspace Communication";
      "${mod}+r" = "workspace \"10: Others\"";

      "${mod}+Shift+a" = "move container to workspace Web 1";
      "${mod}+Shift+s" = "move container to workspace Code 2";
      "${mod}+Shift+d" = "move container to workspace Code 1";
      "${mod}+Shift+f" = "move container to workspace Web 2";
      "${mod}+Shift+q" = "move container to workspace \"4: Others\"";
      "${mod}+Shift+w" = "move container to workspace Terminal";
      "${mod}+Shift+e" = "move container to workspace Communication";
      "${mod}+Shift+r" = "move container to workspace \"10: Others\"";

      "${mod}+Shift+z" = "restart";
      "${mod}+Shift+Esc" =
        "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
      "${mod}+Shift+c" = "reload";
    };
  modes =
    let mod = modifier;
    in
    {
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
      focus_and_move = {
        "h" = "focus left";
        "j" = "focus down";
        "k" = "focus up";
        "l" = "focus right";
        "Shift+o" = "move left";
        "Shift+h" = "move left";
        "Shift+j" = "move down";
        "Shift+k" = "move up";
        "Shift+l" = "move right";
        "Escape" = "mode default";
      };
      quick_focus = { };
    };
}
