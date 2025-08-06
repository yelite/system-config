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

      rbw
      kitty.terminfo
      exiftool
    ]
    ++ optionals useGUI [
      obsidian
      sublime-merge
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
      imv
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

      kdePackages.dolphin
      kdePackages.qtsvg
      kdePackages.breeze
      kdePackages.breeze-icons
      kdePackages.breeze-gtk
      hicolor-icon-theme
    ]
    ++ optionals hostPlatform.isDarwin [
      terminal-notifier
      stats
    ];

  # link ~/.terminfo to /usr/share/terminfo
  # https://github.com/NixOS/nixpkgs/issues/36146#issuecomment-421460165
  systemd.user.tmpfiles.rules = lib.mkIf hostPlatform.isLinux [
    "L+ %h/.terminfo - - - - /usr/share/terminfo"
  ];

  xdg.mimeApps = lib.mkIf isLinuxGUI {
    enable = true;
    defaultApplications = let
      genEntries = {
        app,
        types,
      }:
        lib.genAttrs types (_: app);
    in
      (genEntries {
        app = "imv.desktop";
        types = [
          "image/bmp"
          "image/gif"
          "image/jpeg"
          "image/jpg"
          "image/pjpeg"
          "image/png"
          "image/tiff"
          "image/webp"
          "image/x-bmp"
          "image/x-pcx"
          "image/x-png"
          "image/x-portable-anymap"
          "image/x-portable-bitmap"
          "image/x-portable-graymap"
          "image/x-portable-pixmap"
          "image/x-tga"
          "image/x-xbitmap"
          "image/heic"
        ];
      })
      // (genEntries {
        app = "firefox-devedition.desktop";
        types = [
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "text/html"
          "x-scheme-handler/standardnotes"
          "x-scheme-handler/notion"
          "x-scheme-handler/postman"
          "x-scheme-handler/chrome"
          "application/x-extension-htm"
          "application/x-extension-html"
          "application/x-extension-shtml"
          "application/xhtml+xml"
          "application/x-extension-xhtml"
          "application/x-extension-xht"
        ];
      });
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nix-index-database.comma.enable = true;
    nix-index = {
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
        os = {
          edit = ''[ -z "$NVIM" ] && nvim -- {{filename}} || nvim --server "$NVIM" --remote-send "<C-s><cmd>e {{filename}}<cr>" '';
          editAtLine = ''[ -z "$NVIM" ] && nvim +{{line}} -- {{filename}} || nvim --server "$NVIM" --remote-send "<C-s><cmd>e {{filename}}<cr>" && nvim --server "$NVIM" --remote-send "<cmd>{{line}}<CR>"'';
          openDirInEditor = ''[ -z "$NVIM" ] && nvim -- {{dir}} || nvim --server "$NVIM" --remote {{dir}}'';
          editPreset = "nvim-remote";
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
