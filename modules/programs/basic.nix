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
      bat
      exa
      fd
      fzf

      difftastic

      nix-tree
      nixpkgs-fmt
      cachix

      my-fup-repl
    ] ++
    optionals systemInfo.isLinux [
      steam-run
    ] ++
    optionals (useGUI && systemInfo.isLinux) [
      zeal
      libsForQt5.okular
      feh
      flameshot
      playerctl
      slack
      zoom-us
      notion-app-enhanced
      write_stylus
      reaper
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
    ] ++
    optionals systemInfo.isDarwin [
      terminal-notifier
    ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          syntax-theme = "Nord";
          line-numbers = true;
          line-numbers-minus-style = "#733c3f";
          line-numbers-zero-style = "#4C566A";
          line-numbers-plus-style = "#627354";
          minus-style = "syntax #331b1d";
          minus-emph-style = "normal #733c3f";
          plus-style = "syntax #2b3325";
          plus-emph-style = "normal #627354";
        };
      };
    };

    lazygit = {
      enable = true;
      settings = {
        git.paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never --syntax-theme=Nord";
        };
      };
    };

    ssh = {
      enable = true;
      includes = [ "~/.ssh/config.d/*" ];
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
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };

    mpv = {
      enable = systemInfo.isLinux;
      defaultProfiles = [ "gpu-hq" ];
      config = {
        hwdec = "auto";
        save-position-on-quit = true;
      };
      scripts = [
        pkgs.mpvScripts.autoload
      ] ++ optionals systemInfo.isLinux [
        pkgs.mpvScripts.mpris
      ];
    };
  };

  services = {
    kdeconnect = lib.mkIf systemInfo.isLinux {
      enable = true;
      indicator = true;
    };
  };
}
