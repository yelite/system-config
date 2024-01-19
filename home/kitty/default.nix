{
  config,
  pkgs,
  lib,
  hostPlatform,
  ...
}: let
  cfg = config.myHomeConfig.kitty;
  inherit (lib) mkIf mkEnableOption;
in {
  options = {
    myHomeConfig.kitty = {
      enable = mkEnableOption "kitty";
    };
  };

  config = mkIf cfg.enable {
    home.packages = lib.optionals hostPlatform.isLinux (with pkgs; [
      ueberzug
    ]);

    programs.kitty = {
      enable = true;
      font =
        {
          name = "Hack Nerd Font";
          size = 12;
        }
        // lib.optionalAttrs hostPlatform.isDarwin {
          package = pkgs.nerdfonts.override {
            fonts = ["Hack"];
          };
          size = 14;
        };
      settings = {
        cursor_blink_interval = 0;
        enabled_layouts = "tall:bias=50;full_size=1;mirrored=false, horizontal";
        "mouse_map left click ungrabbed" = "mouse_handle_click selection prompt";
        enable_audio_bell = false;
        visual_bell_duration = "0.3";
        placement_strategy = "top-left";
      };
      shellIntegration.mode = "no-sudo";
      theme = "Tomorrow Night Eighties";
      keybindings = {
        "ctrl+tab" = "no_op";
        "ctrl+shift+tab" = "no_op";
        "super+c" = "copy_to_clipboard";
        "super+v" = "paste_from_clipboard";
        "super+t" = "new_tab";
        "super+w" = "close_tab";
        "super+shift+s" = "new_window";
        "super+shift+w" = "close_window";
        "super+shift+a" = "next_layout";
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
