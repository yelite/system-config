{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.myConfig.desktop;
  inherit (lib) mkIf;
in
  mkIf (cfg.enable && cfg.wayland.enable) {
    home.packages = with pkgs; [
      wev
      wl-clipboard
      cliphist
      xwayland-satellite
      wofi
    ];

    programs = {
      waybar = {
        enable = true;
        systemd = {
          enable = true;
          target = "niri.service";
        };
      };
      swaylock = {
        enable = true;
        package = pkgs.swaylock;
        settings = {
          color = "434C5E";
          font-size = 24;
          inside-color = "ECEFF422";
          inside-ver-color = "81a1c1";
          inside-wrong-color = "bf616a";
          inside-clear-color = "a3be8c";
          line-color = "ECEFF422";
          ring-color = "e5e9f0";
          key-hl-color = "81a1c1";
          separator-color = "e5e9f0";
          indicator-idle-visible = true;
          indicator-radius = 150;
          show-failed-attempts = true;
        };
      };
    };

    services = {
      gammastep = {
        enable = true;
        provider = "geoclue2";

        temperature = {
          night = 5200;
          day = 6500;
        };
      };

      swayidle = {
        enable = true;
        extraArgs = ["-w"];
        systemdTarget = "niri.service";
        events = [
          {
            event = "before-sleep";
            command = "${pkgs.swaylock}/bin/swaylock -f";
          }
          {
            event = "lock";
            command = "${pkgs.swaylock}/bin/swaylock -f";
          }
        ];
        timeouts = [
          {
            timeout = 450;
            command = ''${pkgs.libnotify}/bin/notify-send "Idle" "Screen will be locked in 1 minute" -t 5000 -u low'';
          }
          {
            timeout = 510;
            command = "${pkgs.swaylock}/bin/swaylock -f";
          }
          {
            timeout = 530;
            command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
          }
          {
            timeout = 1100;
            command = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };
    };

    systemd.user.services = {
      sway-audio-idle-inhibit = {
        Unit = {
          Description = "Prevents swayidle from sleeping while any application is outputting or receiving audio.";
          Documentation = "https://github.com/ErikReider/SwayAudioIdleInhibit";
          PartOf = ["niri.service"];
        };
        Service = {
          ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
          Type = "simple";
        };
        Install = {
          WantedBy = ["niri.service"];
        };
      };
    };
  }
