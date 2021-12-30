{ pkgs, ... }:
let
  i3Config = {
    modifier = "Mod1";

    terminal = "${pkgs.kitty}/bin/kitty";
    bars = [{
      position = "top";
      statusCommand = "${pkgs.i3status}/bin/i3status";
    }];
    menu = "${pkgs.rofi}/bin/rofi -show run";

    gaps = {
      bottom = 5;
      horizontal = 5;
      inner = 5;
      left = 5;
      outer = 5;
      right = 5;
      top = 5;
      vertical = 5;
      smartBorders = "no_gaps";
      smartGaps = true;
    };
  };
  i3ExtraConfig = ''
    focus_follows_mouse no
    mouse_warping none
  '';
in
{
  xsession = {
    enable = true;
    scriptPath = ".xsession-hm";

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = i3Config;
      extraConfig = i3ExtraConfig;
    };
  };
}
