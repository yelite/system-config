{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.desktop.i3;
  i3lock-run-unwrapped = (pkgs.writeScriptBin "i3lock-run" (builtins.readFile ./i3lock.sh)).overrideAttrs (old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
  i3lock-run = pkgs.symlinkJoin {
    name = "i3lock-run";
    paths = [i3lock-run-unwrapped];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = "wrapProgram $out/bin/i3lock-run --prefix PATH : ${pkgs.i3lock-color}/bin";
  };
in
  lib.mkIf (cfg.enable && config.myConfig.desktop.enable) {
    home.packages = with pkgs; [
      jq
      xidlehook
    ];

    xsession.windowManager.i3 = {
      enable = true;
      config = import ./config.nix {inherit cfg pkgs;};
      extraConfig = ''
      '';
    };

    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          settings = {
            theme = {
              theme = "ctp-macchiato";
              overrides = {
                separator = "";
              };
            };
            icons_format = " <span size='x-large'>{icon} </span>";
          };
          icons = "material-nf";
          blocks = [
            {
              block = "music";
              format = "$icon{$combo.str(max_w:75)$play|}";
            }
            {
              block = "sound";
              show_volume_when_muted = true;
              max_vol = 100;
              format = "$icon";
            }
            {
              block = "cpu";
              format = "$icon";
              format_alt = "$icon{$utilization.eng(w:2)} ";
              interval = 10;
            }
            {
              block = "memory";
              format = "$icon";
              format_alt = "$icon{$mem_used_percents.eng(w:2)} ";
              interval = 10;
            }
            {
              block = "temperature";
              format = "<span size='x-large'>$icon</span>";
              format_alt = "$icon{$min min, $average avg, $max max} ";
              good = 68;
              idle = 68;
              info = 75;
              warning = 81;

              interval = 5;

              theme_overrides = {
                good_bg = "#363a4f";
                good_fg = "#cad3f5";
              };
            }
            {
              block = "net";
              format = "$icon ";
              # Nested format just to keep text and icons align vertically
              format_alt = "$icon^icon_net_down{$speed_down.eng(w:2, prefix:K) {^icon_net_up{$speed_up.eng(w:2, prefix:K)}}} ";
            }
            {
              block = "tea_timer";
              format = "^icon_time{$minutes:$seconds |}";
              done_cmd = "${pkgs.libnotify}/bin/notify-send 'Timer Finished'";
            }
            {
              block = "time";
              format = " $timestamp.datetime(f:'%a %F %R') ";
              interval = 60;
            }
            {
              block = "notify";
              format = "$icon";
            }
          ];
        };
      };
    };

    # TODO: move to standalone screen lock module
    systemd.user.services.xidlehook = let
      notify-cmd = ''${pkgs.libnotify}/bin/notify-send "Idle" "Sleeping in 1 minute" -t 5000 -u low'';
      script = pkgs.writeShellScript "xidlehook" (lib.concatStringsSep " " [
        "${pkgs.xidlehook}/bin/xidlehook"
        "--detect-sleep"
        "--not-when-fullscreen"
        "--not-when-audio"
        ''--socket /tmp/xidlehook.sock''
        ''--timer 420 ${lib.escapeShellArgs [notify-cmd ""]}''
        ''--timer 60 ${lib.escapeShellArgs ["${i3lock-run}/bin/i3lock-run" ""]}''
        ''--timer 10 ${lib.escapeShellArgs ["xset dpms force off" ""]}''
        ''--timer 600 ${lib.escapeShellArgs ["systemctl suspend" ""]}''
      ]);
    in {
      Unit = {
        Description = "xidlehook";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
        ConditionEnvironment = ["DISPLAY"];
      };

      Install = {WantedBy = ["graphical-session.target"];};

      Service = {
        Type = "simple";
        ExecStart = "${script}";
      };
    };

    systemd.user.services.xss-lock = {
      Unit = {
        Description = "xss-lock";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };

      Install = {WantedBy = ["graphical-session.target"];};

      Service = {
        ExecStart = lib.concatStringsSep " " [
          "${pkgs.xss-lock}/bin/xss-lock"
          "-s \${XDG_SESSION_ID}"
          "-- ${i3lock-run}/bin/i3lock-run"
        ];
      };
    };
  }
