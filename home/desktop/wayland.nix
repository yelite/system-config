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
        settings = {
          mainBar = {
            position = "top";
            height = 25;
            spacing = 0;
            modules-left = ["niri/workspaces" "niri/window"];
            modules-center = ["privacy"];
            modules-right = ["mpris" "wireplumber" "wireplumber#source" "network" "load" "tray" "clock" "idle_inhibitor"];

            "niri/window" = {
              format = "󰖯 {title}";
              separate-outputs = true;
              rewrite = {
                "(^.{60}).*(.{30}$)" = "$1 ... $2";
              };
            };

            mpris = {
              format = "{player_icon} {status_icon} {dynamic}";
              dynamic-order = ["artist" "title"];
              player-icons = {
                default = "󰝚";
                firefox = "󰖟";
              };
              status-icons = {
                playing = "󰐊";
                paused = "󰏤";
                stopped = "󰓛";
              };
              dynamic-len = 70;
              interval = 0;
            };

            wireplumber = {
              node-type = "Audio/Sink";
              format = "{icon}";
              format-muted = "󰝟";
              tooltip-format = "{node_name} {volume}%";
              scroll-step = 5;
              on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
              on-click-right = "${pkgs.helvum}/bin/helvum";
              format-icons = ["󰕿" "󰖀" "󰕾"];
            };

            "wireplumber#source" = {
              node-type = "Audio/Source";
              format = "󰍬";
              format-muted = "󰍭";
              tooltip-format = "{node_name} {volume}%";
              scroll-step = 5;
              on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              on-click-right = "${pkgs.helvum}/bin/helvum";
            };

            privacy = {
              icon-size = 16;
            };

            network = {
              format-wifi = "󰤨";
              format-ethernet = "󰈀";
              format-disconnected = "󰤭";
              tooltip-format-wifi = "{essid} ({signalStrength}%)";
              tooltip-format-ethernet = "{ifname}: {ipaddr}";
              on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
            };

            load = {
              interval = 15;
              format = "󰓅";
            };

            tray = {
              spacing = 10;
              show-passive-items = false;
            };

            clock = {
              format = "{:%a %F %R}";
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              interval = 30;
              calendar = {
                mode = "month";
              };
            };

            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = "";
                deactivated = "";
              };
              tooltip-format-activated = "Idle inhibitor on";
              tooltip-format-deactivated = "Idle inhibitor off";
            };
          };
        };
        style = ''
          * {
            border: none;
            border-radius: 0;
            font-family: "Material Design Icons", "JetBrains Mono", monospace;
            font-size: 14px;
            min-height: 0;
            color: #cad3f5;
          }

          window#waybar {
            background-color: #24273a;
            color: #cad3f5;
            transition-property: background-color;
            transition-duration: .5s;
          }

          #window {
            padding-left: 8px;
          }

          #workspaces button {
            border-right: 1px solid #4c566a;
            min-width: 40px;
            background-color: transparent;
          }

          #workspaces button:hover {
            text-shadow: inherit;
            background: rgba(0, 0, 0, 0.3);
          }

          #workspaces button.active {
            box-shadow: inset 0 2px #64748b;
          }

          #workspaces button.focused {
            box-shadow: inset 0 2px #5e81ac;
            background-color: #64748b;
          }

          #mpris {
            padding: 0 8px;
          }

          #mpris.playing {
            background-color: #464c67;
          }

          #wireplumber {
            min-width: 30px;
            background-color: #363a4f;
          }

          #load {
            padding: 0 10px;
            color: #cad3f5;
            background-color: #363a4f;
            font-size: 16px;
          }

          #clock,
          #network,
          #tray,
          #idle_inhibitor {
            padding: 0 8px;
            color: #cad3f5;
            background-color: #363a4f;
          }

          #tray > .passive {
            -gtk-icon-effect: dim;
          }

          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            background-color: #eb4d4b;
          }

          #idle_inhibitor {
            padding-left: 4px;
            padding-right: 4px;
            background-color: #363a4f;
            font-size: 20px;
          }

          #idle_inhibitor.activated {
            background-color: #ecf0f1;
            color: #2d3436;
          }
        '';
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
          After = ["niri.service"];
        };
        Service = {
          ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
          Type = "simple";
        };
        Install = {
          WantedBy = ["niri.service"];
        };
      };

      # TODO: use the native xwayland-satellite integration in the next stable niri release
      xwayland-satellite = {
        Unit = {
          Description = "Xwayland outside your Wayland";
          Documentation = "https://github.com/Supreeeme/xwayland-satellite";
          PartOf = ["niri.service"];
          After = ["niri.service"];
        };
        Service = {
          ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 1;
        };
        Install = {
          WantedBy = ["niri.service"];
        };
      };
    };
  }
