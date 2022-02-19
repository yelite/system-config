{ config, pkgs, lib, ... }:
let useGUI = config.myHomeConfig.xserver.enable;
in
lib.mkIf useGUI {
  home.packages = with pkgs; [
    zeal
    neovide
    flameshot
    slack
    zoom-us
    notion-app-enhanced
    realvnc-vnc-viewer
    (vivaldi.override {
      commandLineArgs = [
        "--use-gl=desktop"
        "--enable-features=VaapiVideoDecoder"
        "--force-dark-mode" # Make prefers-color-scheme selector to choose dark theme
      ];
    })
    vivaldi-widevine
    vivaldi-ffmpeg-codecs
    standardnotes

    xorg.xev
    xorg.xmodmap
  ];
}
