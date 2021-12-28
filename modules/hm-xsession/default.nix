{ pkgs, ... }:
let
  theme-packages = pkgs.callPackage ./theme-packages.nix { };
  theme-config = pkgs.writeTextFile {
    name = "sddm-theme-user-config";
    destination = "/share/sddm/themes/breeze514/theme.conf.user";
    text = ''
      [General]
      type=image
      background=${./lockscreen_wallpaper.jpg}
      Font="Overpass"
      FontSize=14
      ClockSize=48
      DateSize=24
    '';
  };
in
{
  environment.systemPackages = [
    theme-config

    theme-packages.sddm-breeze514

    pkgs.libsForQt5.qt5.qtgraphicaleffects
    pkgs.libsForQt5.breeze-qt5
    pkgs.libsForQt5.breeze-icons
    pkgs.libsForQt5.plasma-framework
    pkgs.libsForQt5.plasma-workspace
    pkgs.libsForQt5.kdeclarative
  ];

  fonts =
    {
      fonts = with pkgs; [
        roboto
      ];
    };

  services.xserver.displayManager = {
    sddm = {
      enable = true;
      theme = "breeze514";

      settings = {
        X11 = {
          EnableHiDPI = true;
          ServerArguments = "-nolisten tcp -dpi 192";
        };
      };
    };

    session = [
      {
        manage = "desktop";
        name = "home-manager-session";
        start = "exec $HOME/.xsession-hm";
      }
    ];
    defaultSession = "home-manager-session";
  };
}
