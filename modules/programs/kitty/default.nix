{ config, pkgs, lib, ... }:
let
  cfg = config.myHomeConfig.kitty;
  inherit (lib) types mkIf mkEnableOption mkOption;
in
{
  options = {
    myHomeConfig.kitty = {
      enable = mkEnableOption "kitty";
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "Hack Nerd Font";
        size = 12;
      };
      settings = {
        cursor_blink_interval = 0;
      };
      keybindings = {
        "super+c" = "copy_to_clipboard";
        "super+v" = "paste_from_clipboard";
        "super+n" = "new_window";
        "super+t" = "new_tab";
        "super+w" = "close_tab";
        "super+shift+w" = "close_window";
        "super+1" = "goto_tab 1";
        "super+2" = "goto_tab 2";
        "super+3" = "goto_tab 3";
        "super+4" = "goto_tab 4";
        "super+5" = "goto_tab 5";
        "super+equal" = "change_font_size all +2.0";
        "super+minus" = "change_font_size all -2.0";
        "super+0" = "change_font_size all 0";
      };
    };
  };
}
