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
      ranger

      ripgrep
      exa
      fd

      git
      lazygit

      nix-tree
      nixpkgs-fmt
      cachix
    ] ++
    optionals systemInfo.isLinux [
      steam-run
    ] ++
    optionals (useGUI && systemInfo.isLinux) [
      zeal
      libsForQt5.okular
      flameshot
      playerctl
      slack
      zoom-us
      notion-app-enhanced
      write_stylus
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
    ];

  programs = {
    keychain = lib.mkIf systemInfo.isLinux {
      # TODO: Investigate the compatibility with sddm and re-enable this
      enable = false;
      enableBashIntegration = true;
      enableFishIntegration = true;

      keys = [ "id_ed25519" ];
    };

    ssh = {
      enable = true;
      matchBlocks = lib.mkMerge [
        {
          "*" = {
            identityFile = "~/.ssh/id_ed25519";
          };
        }
        (lib.mkIf systemInfo.isDarwin
          {
            "*" = {
              extraOptions = {
                UseKeychain = "yes";
                AddKeysToAgent = "yes";
              };
            };
          }
        )
      ];
    };

    mpv = {
      enable = true;
      defaultProfiles = [ "gpu-hq" ];
      config = {
        hwdec = "auto";
        save-position-on-quit = true;
      };
      scripts = [
        pkgs.mpvScripts.autoload
        pkgs.mpvScripts.mpris
      ];
    };
  };
}