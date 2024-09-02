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
    else if config ? myConfig.desktop.enable
    then config.myConfig.desktop.enable
    else false;
  isLinuxGUI = hostPlatform.isLinux && useGUI;
in {
  home.packages = with pkgs;
    [
      wget
      unzip

      ripgrep
      bat
      eza
      fd
      fzf
      tree
      gdu
      tmux

      difftastic

      nix-tree
      nixpkgs-fmt
      nvd
      alejandra
      cachix

      flake-repl

      age
      gopass
      rbw
      kitty.terminfo
      exiftool
    ]
    ++ optionals useGUI [
      obsidian
    ]
    ++ optionals (useGUI && !(hostPlatform.isx86 && hostPlatform.isDarwin)) [
      # TODO: revisit this: supersonic cannot be built on x86 mac
      supersonic
    ]
    ++ optionals hostPlatform.isLinux [
      lm_sensors
      smartmontools
      usbutils
      dnsutils
      lsof
    ]
    ++ optionals isLinuxGUI [
      zeal
      libsForQt5.okular
      feh
      flameshot
      satty
      playerctl
      zoom-us
      write_stylus
      reaper
      realvnc-vnc-viewer
      chromium
      picard
      rsgain
      pinentry-qt

      gimp-with-plugins
      gimpPlugins.resynthesizer

      kdePackages.dolphin
      kdePackages.qtsvg
      kdePackages.breeze
      kdePackages.breeze-icons
      kdePackages.breeze-gtk
      hicolor-icon-theme
    ]
    ++ optionals hostPlatform.isDarwin [
      terminal-notifier
    ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
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
      enable = !config.myConfig.isServer; # always use agent forward on server
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

    yazi = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        preview = {
          max_width = 800;
          max_height = 800;
        };
      };
      keymap = {
        manager.prepend_keymap = [
          {
            on = ["<Enter>"];
            run = "enter";
            desc = "Enter the child directory";
          }
        ];
      };
    };
  };

  services = {
    playerctld = lib.mkIf isLinuxGUI {
      enable = true;
    };
  };

  systemd.user.startServices = "sd-switch";

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
}
