{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.myConfig.desktop;
in
  lib.mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        material-design-icons
        material-symbols

        lexend
        merriweather
        source-han-sans
        source-han-serif
        source-han-mono
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        roboto-mono
        overpass

        (nerdfonts.override {
          fonts = ["Hack"];
        })
      ];

      enableDefaultPackages = false;

      fontconfig.subpixel = lib.mkIf cfg.highDPI {
        rgba = "none";
        lcdfilter = "none";
      };

      fontconfig.defaultFonts = {
        serif = ["Noto Serif" "Noto Sans CJK SC" "Noto Sans Symbols" "Noto Color Emoji"];
        sansSerif = ["Noto Sans" "Noto Sans CJK SC" "Noto Sans Symbols" "Noto Color Emoji"];
        monospace = ["Hack Nerd Font Mono" "Noto Sans Symbols" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
    };
  }
