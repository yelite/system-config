{ config, pkgs, lib, hostPlatform, ... }:
let
  inherit (lib) optionals;
  useGUI =
    if config?myHomeConfig.xserver.enable then
      config.myHomeConfig.xserver.enable
    else if hostPlatform.isDarwin then
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

      zk

      my-fup-repl
    ] ++
    optionals hostPlatform.isLinux [
      steam-run
    ] ++
    optionals (useGUI && hostPlatform.isLinux) [
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
          "--enable-features=VaapiVideoDecoder"
          "--force-dark-mode" # Make prefers-color-scheme selector to choose dark theme
        ];
      })
      widevine-cdm
      vivaldi-ffmpeg-codecs
      standardnotes
    ] ++
    optionals hostPlatform.isDarwin [
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
        git = {
          paging = {
            colorArg = "always";
            pager = "delta --dark --paging=never --syntax-theme=Nord";
          };
          log = {
            showGraph = "always";
          };
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
        (lib.mkIf hostPlatform.isDarwin
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
      enable = hostPlatform.isLinux;
      defaultProfiles = [ "gpu-hq" ];
      config = {
        hwdec = "auto";
        save-position-on-quit = true;
      };
      scripts = [
        pkgs.mpvScripts.autoload
      ] ++ optionals hostPlatform.isLinux [
        pkgs.mpvScripts.mpris
      ];
    };
  };

  services = {
    kdeconnect = lib.mkIf hostPlatform.isLinux {
      enable = true;
      indicator = true;
    };
  };
}