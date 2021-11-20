{ pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      material-design-icons

      merriweather
      source-han-sans
      source-han-serif
      source-han-mono
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

      (nerdfonts.override { fonts = [ "FiraCode" "Inconsolata" ]; })
    ];

    enableDefaultFonts = false;

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Noto Sans CJK SC" "Noto Sans Symbols" "Noto Color Emoji" ];
      sansSerif = [ "Noto Sans" "Noto Sans CJK SC" "Noto Sans Symbols" "Noto Color Emoji" ];
      monospace = [ "FiraCode Nerd Font Mono" "Noto Sans Symbols" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  services = {
    geoclue2.enable = true;

    xserver = {
      enable = true;

      displayManager.sddm.enable = true;
      displayManager.session = [
        {
          manage = "window";
          name = "home-manager";
          start = "exec $HOME/.xsession-hm";
        }
      ];

      desktopManager.plasma5.enable = true;

      libinput = {
        enable = true;
        # disable mouse acceleration
        mouse.accelProfile = "flat";
        mouse.accelSpeed = "0";
        mouse.middleEmulation = false;
      };
    };
  };
}
