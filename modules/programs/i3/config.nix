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
    {
      command = ''neovide ~/neorg -- -c "set title titlestring=NoteScratchpad"'';
      always = false;
      notification = false;
    }
  ];

  workspaceOutputAssign = let inherit (cfg) secondaryMonitorName; in
    [
      {
        workspace = "code";
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
        workspace = "terminal";
        output = secondaryMonitorName;
      }
      {
        workspace = "comm";
        output = secondaryMonitorName;
      }
      {
        workspace = "others";
        output = secondaryMonitorName;
      }
    ];

  assigns = { };

  window.commands = [
    {
      command = "move scratchpad; resize set width 62 ppt height 62 ppt";
      criteria = { class = "neovide"; title = "NoteScratchpad"; };
    }
    {
      command = "move position center";
      criteria = { window_role = "pop-up"; class = "Vivaldi-stable"; };
    }
  ];
  floating.criteria = [
    { window_role = "pop-up"; }
    { class = "zoom"; title = "Settings"; }
  ];

  focus = {
    newWindow = "focus";
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
      "${mod}+Shift+m" = ''exec --no-startup-id "i3-input -F 'move container to workspace \\"%s\\"; workspace \\"%s\\"'"'';
      "${mod}+Shift+o" = "move container to output right; focus output right";
      "${mod}+Shift+p" = "move workspace to output right";

      "${mod}+Shift+Return" = "exec ${terminal}";
      "${mod}+Shift+g" = "fullscreen toggle";
      "${mod}+Shift+/" = "floating toggle";
      "${mod}+Shift+x" = "kill";
      "${mod}+x" = ''exec --no-startup-id i3-input -f "pango:Hack Nerd Font Mono 13"'';

      "${mod}+a" = "workspace code2";
      "${mod}+s" = "workspace web";
      "${mod}+d" = "workspace code";
      "${mod}+q" = "workspace others";
      "${mod}+w" = "workspace terminal";
      "${mod}+e" = "workspace comm";
      "${mod}+1" = "scratchpad show";
      "${mod}+3" = ''[title="NoteScratchpad" class="neovide"] scratchpad show'';

      "${mod}+Shift+a" = "move container to workspace code2; workspace code2";
      "${mod}+Shift+s" = "move container to workspace web; workspace web";
      "${mod}+Shift+d" = "move container to workspace code; workspace code";
      "${mod}+Shift+q" = "move container to workspace others; workspace others";
      "${mod}+Shift+w" = "move container to workspace terminal; workspace terminal";
      "${mod}+Shift+e" = "move container to workspace comm; workspace comm";
      "${mod}+Shift+1" = "move scratchpad; resize set width 62 ppt height 62 ppt";

      "${mod}+Shift+z" = "restart";
      "${mod}+Shift+esc" =
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
      passthrough = { "${mod}+F12" = "mode default"; };
    };
}
