{ config, pkgs, lib, ... }:
let useGUI = config.myHomeConfig.xserver.enable;
in
lib.mkIf useGUI {
  home.packages = with pkgs; [
    zeal
    neovide
    realvnc-vnc-viewer
    vivaldi
    vivaldi-widevine
    vivaldi-ffmpeg-codecs
    standardnotes
  ];
}
