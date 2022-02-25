{ config, pkgs, lib, systemInfo, ... }:
let
  inherit (lib) optionals;
  useGUI =
    if config?myHomeConfig.xserver.enable then
      config.myHomeConfig.xserver.enable
    else if systemInfo.isDarwin then
      true
    else
      false;
in
{
  home.packages = with pkgs;
    [
      wget
      unzip

      ripgrep
      exa
      fd

      git
      lazygit

      nix-index
      nix-tree
      nixpkgs-fmt
      cachix
    ] ++
    optionals systemInfo.isLinux [
      steam-run
    ] ++
    optionals (useGUI && systemInfo.isLinux) [
      zeal
      flameshot
      playerctl
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

  programs = {
    keychain = lib.mkIf systemInfo.isLinux {
      # TODO: Investigate the compatibility with sddm and re-enable this
      enable = false;
      enableBashIntegration = true;
      enableFishIntegration = true;

      keys = [ "id_ed25519" ];
    };
  };
}
