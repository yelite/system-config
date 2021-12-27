{ pkgs, ... }:
let
  theme-packages = pkgs.callPackage ./theme-packages.nix { };
  theme-config = pkgs.writeTextFile {
    name = "sddm-theme-user-config";
    destination = "/share/sddm/themes/slice/theme.conf.user";
    text = ''
      [General]
      font=Roboto
      color_bg=#e5e5e5
      color_main=#345470
      color_dimmed=#7592a3
      color_contrast=#f9f9f9
      color_text=#345470
      color_text_bg=#aad0dfe8
      color_icon_bg=#aad0dfe8
      color_error_text=#a34c4e
      color_error_bg=#11a34c4e
    '';
  };
in
{
  environment.systemPackages = [
    theme-config

    theme-packages.sddm-slice

    pkgs.libsForQt5.qt5.qtgraphicaleffects
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
      theme = "slice";

      settings = {
        X11 = {
          EnableHiDPI = true;
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
