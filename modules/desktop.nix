{ pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      material-design-icons

      merriweather
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    enableDefaultFonts = false;

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Noto Color Emoji" ];
      sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
      monospace = [ "FiraCode Nerd Font Mono" "Noto Color Emoji" ];
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
