{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.myConfig.desktop;
  inherit (lib) mkIf;
in {
  imports = [
    ./wayland.nix
    ./toggle-source.nix
    inputs.niri.homeModules.niri
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      albert
    ];
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.apple-cursor;
      name = "macOSMonterey";
      size = 48;
    };
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = [
        (pkgs.fcitx5-rime.override
          {
            rimeDataPkgs = [
              pkgs.rime-data
              pkgs.rime-dict
              (pkgs.runCommandLocal "my-rime-config" {} ''
                mkdir -p $out/share/

                cp -r ${../rime} $out/share/rime-data
              '')
            ];
          })
      ];
    };

    # TODO: move all fcitx config into nix
    xdg.dataFile."fcitx5/themes/FluentDark-my" = {
      source = "${pkgs.fcitx5-fluent-dark}/share/fcitx5/themes/FluentDark-solid";
    };
  };
}
