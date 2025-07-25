{
  pkgs,
  lib,
  ...
}: let
  playerctl = "${pkgs.playerctl}/bin/playerctl";
in {
  settings = {
    general = {
      gaps_out = 5;
      gaps_in = 5;
      cursor_inactive_timeout = 15;
    };
    decoration = {
      rounding = 5;
    };
    input = {
      sensitivity = 0.4;
      accel_profile = "flat";
      follow_mouse = 2;
      float_switch_override_focus = 0;
    };
    misc = {
      disable_splash_rendering = true;
      force_hypr_chan = true;
      key_press_enables_dpms = true;
    };

    xwayland = {
      force_zero_scaling = true;
    };

    bezier = [
      "ease-out,0.05,0.7,0.5,0.95"
    ];

    animation = [
      "specialWorkspace,1,2,ease-out,slidevert"
    ];

    env = [
      "NIXOS_OZONE_WL,1"
    ];

    exec-once = [
      "eww open bar"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
      "[workspace special:term silent] kitty"
      "[workspace special:notes silent] neovide --nofork ~/notes"
      "[workspace special:music silent] supersonic"
    ];

    windowrule = [
    ];

    windowrulev2 = [
      "center,class:^(gcr-prompter)$"
      "idleinhibit focus,class:^(mpv)$"

      "float,title:^Vivaldi Settings:"
      "size 60% 60%,title:^Vivaldi Settings:"
      "center,title:^Vivaldi Settings:"
    ];

    workspace = [
      "1, default:true, monitor:HDMI-A-3"
      "2, default:true, monitor:HDMI-A-1"
    ];

    "$mod" = "ALT";
    "$term" = "${pkgs.kitty}/bin/kitty";

    "$left" = "h";
    "$down" = "j";
    "$up" = "k";
    "$right" = "l";

    bind = lib.flatten [
      "$mod SHIFT, Return, exec, $term"
      "$mod SHIFT, x, killactive,"
      "$mod SHIFT CTRL, x, exec, wlogout"

      "$mod, $left, movefocus, l"
      "$mod, $down, movefocus, d"
      "$mod, $up, movefocus, u"
      "$mod, $right, movefocus, r"
      "$mod SHIFT, $left, movewindow, l"
      "$mod SHIFT, $down, movewindow, d"
      "$mod SHIFT, $up, movewindow, u"
      "$mod SHIFT, $right, movewindow, r"

      "SUPER, tab, focuscurrentorlast"

      "$mod, a, workspace, name:code1"
      "$mod, s, workspace, name:web"
      "$mod, d, workspace, name:code2"
      "$mod, q, workspace, 1"
      "$mod, w, workspace, 2"
      "$mod, e, workspace, 3"

      "$mod SHIFT, a, moveworkspacetomonitor, name:code1 +1"
      "$mod SHIFT, a, workspace, name:code1"
      "$mod SHIFT, a, focusmonitor, -1"

      "$mod SHIFT, s, moveworkspacetomonitor, name:web +1"
      "$mod SHIFT, s, workspace, name:web"
      "$mod SHIFT, s, focusmonitor, -1"

      "$mod SHIFT, d, moveworkspacetomonitor, name:code2 +1"
      "$mod SHIFT, d, workspace, name:code2"
      "$mod SHIFT, d, focusmonitor, -1"

      "$mod SHIFT, q, moveworkspacetomonitor, name:1 +1"
      "$mod SHIFT, q, workspace, 1"
      "$mod SHIFT, q, focusmonitor, -1"

      "$mod SHIFT, w, moveworkspacetomonitor, name:2 +1"
      "$mod SHIFT, w, workspace, 2"
      "$mod SHIFT, w, focusmonitor, -1"

      "$mod SHIFT, e, moveworkspacetomonitor, name:3 +1"
      "$mod SHIFT, e, workspace, 3"
      "$mod SHIFT, e, focusmonitor, -1"

      "$mod, 1, togglespecialworkspace, term"
      "$mod SHIFT, 1, focusmonitor, +1"
      "$mod SHIFT, 1, togglespecialworkspace, term"
      "$mod SHIFT, 1, focusmonitor, -1"

      "$mod, 2, togglespecialworkspace, notes"
      "$mod SHIFT, 2, focusmonitor, +1"
      "$mod SHIFT, 2, togglespecialworkspace, notes"
      "$mod SHIFT, 2, focusmonitor, -1"

      "$mod, 3, togglespecialworkspace, music"
      "$mod SHIFT, 3, focusmonitor, +1"
      "$mod SHIFT, 3, togglespecialworkspace, music"
      "$mod SHIFT, 3, focusmonitor, -1"

      "$mod, o, focusmonitor, +1"
      "$mod SHIFT, o, movewindow, mon:+1"
      "$mod, p, focusurgentorlast,"
      "$mod SHIFT, p, movecurrentworkspacetomonitor, +1"
      "$mod SHIFT, p, focusmonitor, +1"

      "$mod SHIFT, semicolon, swapactiveworkspaces, current +1"

      "$mod SHIFT, /, togglefloating"
      "$mod SHIFT, g, fullscreen"

      "$mod, space, exec, wofi --show drun"
      "$mod SHIFT, c, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

      ", XF86AudioPlay, exec, ${playerctl} play-pause"
      ", XF86AudioForward, exec, ${playerctl} next"
      ", XF86AudioNext, exec, ${playerctl} next"
      ", XF86AudioPrev, exec, ${playerctl} previous"

      "$mod CTRL SHIFT, 1, exec, sleep 0.7 && hyprctl dispatch dpms off"
      "$mod CTRL SHIFT, 2, exec, systemctl suspend"
      "$mod CTRL SHIFT, 3, exec, systemctl hibernate"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };

  extraConfig = ''
    # Move submap
    bind = $mod, m, submap, movewindow
    submap = movewindow

    bind = ,a,movetoworkspace,name:code1
    bind = ,a,submap,reset

    bind = ,s,movetoworkspace,name:web
    bind = ,s,submap,reset

    bind = ,d,movetoworkspace,name:code2
    bind = ,d,submap,reset

    bind = ,q,movetoworkspace,1
    bind = ,q,submap,reset

    bind = ,w,movetoworkspace,2
    bind = ,w,submap,reset

    bind = ,e,movetoworkspace,3
    bind = ,e,submap,reset

    bind = ,1,movetoworkspace,special:term
    bind = ,1,submap,reset

    bind = ,2,movetoworkspace,special:notes
    bind = ,2,submap,reset

    bind = ,3,movetoworkspace,special:music
    bind = ,3,submap,reset

    bind = ,escape,submap,reset

    submap = reset

    # Resize submap
    bind = $mod SHIFT, r, submap, resize
    submap = resize

    binde = ,$right,resizeactive,10 0
    binde = ,$left,resizeactive,-10 0
    binde = ,$up,resizeactive,0 -10
    binde = ,$down,resizeactive,0 10

    bind = ,escape,submap,reset

    submap = reset
  '';
}
