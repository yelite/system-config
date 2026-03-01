{
  config,
  pkgs,
  lib,
  hostPlatform,
  ...
}:
lib.mkIf config.myConfig.kitty.enable {
  home.packages = lib.optionals hostPlatform.isLinux (with pkgs; [
    ueberzugpp
  ]);

  programs.kitty = {
    enable = true;
    font =
      {
        name = "Hack Nerd Font";
        size = 12;
      }
      // lib.optionalAttrs hostPlatform.isDarwin {
        package = pkgs.nerd-fonts.hack;
        size = 16;
      };
    settings = {
      cursor_blink_interval = 0;
      enabled_layouts = "grid, stack";
      "mouse_map left click ungrabbed" = "mouse_handle_click selection prompt";
      enable_audio_bell = false;
      visual_bell_duration = "0.3";
      placement_strategy = "top-left";
      macos_option_as_alt = "yes";
      tab_bar_min_tabs = 1;
      tab_title_template = "{' ' if layout_name == 'stack' and num_windows > 1 else ''}{'['+str(num_windows)+'] ' if num_windows > 1 else ''}{title}";
    };
    shellIntegration.mode = "no-sudo";
    themeFile = "Tomorrow_Night_Eighties";
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
      "super+shift+d" = "detach_tab ask";
      "super+1" = "goto_tab 1";
      "super+2" = "goto_tab 2";
      "super+3" = "goto_tab 3";
      "super+4" = "goto_tab 4";
      "super+5" = "goto_tab 5";
      "super+6" = "goto_tab 6";
      "super+equal" = "change_font_size all +2.0";
      "super+minus" = "change_font_size all -2.0";
      "super+0" = "change_font_size all 0";
    };
  };
}
