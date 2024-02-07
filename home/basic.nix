{
  config,
  pkgs,
  lib,
  hostPlatform,
  ...
}: let
  inherit (lib) optionals;
  useGUI =
    if hostPlatform.isDarwin
    then true
    else if config ? myHomeConfig.display.enable
    then config.myHomeConfig.display.enable
    else false;
  isLinuxGUI = hostPlatform.isLinux && useGUI;
  obsidian = lib.throwIf (lib.versionOlder "1.5.3" pkgs.obsidian.version) "Obsidian no longer requires EOL Electron" (
    pkgs.obsidian.override {
      electron = pkgs.electron_25.overrideAttrs (_: {
        meta.knownVulnerabilities = []; # NixOS/nixpkgs#273611
      });
    }
  );
in {
  home.packages = with pkgs;
    [
      wget
      unzip
      ranger

      ripgrep
      bat
      eza
      fd
      fzf

      difftastic

      nix-tree
      nixpkgs-fmt
      alejandra
      cachix

      flake-repl

      age
      gopass
      gopass-jsonapi
    ]
    ++ optionals useGUI [
      obsidian
    ]
    ++ optionals (useGUI && !(hostPlatform.isx86 && hostPlatform.isDarwin)) [
      # TODO: revisit this: supersonic cannot be built on x86 mac
      supersonic
    ]
    ++ optionals isLinuxGUI [
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
      chromium
      vivaldi
      standardnotes
      picard
    ]
    ++ optionals hostPlatform.isDarwin [
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
      includes = [
        {path = "~/.config/git/config.inc";}
      ];
      extraConfig = {
        init.defaultBranch = "main";
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
      includes = ["~/.ssh/config.d/*"];
      addKeysToAgent = "yes";
      matchBlocks = lib.mkMerge [
        {
          "*" = {
            identityFile = "~/.ssh/id_ed25519";
          };
        }
        (
          lib.mkIf hostPlatform.isDarwin
          {
            "*" = {
              extraOptions = {
                IgnoreUnknown = "UseKeychain";
                UseKeychain = "yes";
              };
            };
          }
        )
      ];
    };

    mpv = {
      enable = isLinuxGUI;
      defaultProfiles = ["gpu-hq"];
      config = {
        hwdec = "auto";
        save-position-on-quit = true;
      };
      scripts =
        [
          pkgs.mpvScripts.autoload
        ]
        ++ optionals hostPlatform.isLinux [
          pkgs.mpvScripts.mpris
        ];
    };
  };

  services = {
    playerctld = lib.mkIf isLinuxGUI {
      enable = true;
    };

    gpg-agent = lib.mkIf isLinuxGUI {
      enable = true;
      pinentryFlavor = "qt";
    };
  };

  systemd.user.services.kdeconnect-indicator = lib.mkIf isLinuxGUI {
    Unit = {
      Description = "kdeconnect-indicator";
      PartOf = ["hm-graphical-session.target"];
    };

    Install = {WantedBy = ["hm-graphical-session.target"];};

    Service = {
      Environment = "PATH=${config.home.profileDirectory}/bin";
      ExecStart = "${pkgs.plasma5Packages.kdeconnect-kde}/bin/kdeconnect-indicator";
      Restart = "on-abort";
    };
  };

  xdg.configFile."ranger/rc.conf".source = ./ranger.rc.conf;
}
