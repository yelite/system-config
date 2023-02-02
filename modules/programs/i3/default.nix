{ config, pkgs, lib, ... }:
let
  cfg = config.myHomeConfig.i3;
  inherit (lib) types mkIf mkEnableOption mkOption;
  i3lock-run-unwrapped = (pkgs.writeScriptBin "i3lock-run" (builtins.readFile ./i3lock.sh)).overrideAttrs (old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
  i3lock-run = pkgs.symlinkJoin {
    name = "i3lock-run";
    paths = [ i3lock-run-unwrapped ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = "wrapProgram $out/bin/i3lock-run --prefix PATH : ${pkgs.i3lock-color}/bin";
  };
in
{
  options = {
    myHomeConfig.i3 = {
      enable = mkEnableOption "i3";

      secondaryMonitorName = mkOption {
        type = types.str;
        default = "primary";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jq
    ];

    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = import ./config.nix { inherit cfg pkgs; };
      extraConfig = ''
      '';
    };

    services = {
      screen-locker = {
        enable = true;
        lockCmd = "${i3lock-run}/bin/i3lock-run";
        inactiveInterval = 10;
      };
      polybar = {
        enable = false;
        package = pkgs.polybar.override {
          i3GapsSupport = true;
          nlSupport = true;
          iwSupport = true;
          alsaSupport = true;
          githubSupport = true;
          mpdSupport = true;
        };
        script = ''
          for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
              MONITOR=$m polybar --reload top &
          done
        '';
        config = {
          "bar/top" = {
            monitor = "\${env:MONITOR:}";
            bottom = false;
            module-margin = "1.5";
            modules-left = [
              "date"
              "wireless-network"
              "audio"
              "cpu"
              "memory"
            ];
            modules-right = [
              "i3"
            ];
          };
        };
        settings = {
          "module/cpu" = {
            type = "internal/cpu";
            interval = 5.0;
            warn-percentage = 75;
          };
          "module/memory" = {
            type = "internal/memory";
            interval = 5.0;
            warn-percentage = 85;
          };
          "module/wireless-network" = {
            type = "internal/network";
            # TODO: Paramterize this
            interface = "wlp5s0";
          };
          "module/date" = {
            type = "internal/date";
            interval = 2.0;
            date = "%a %F";
            time = "%H:%M";
            time-alt = "%H:%M:%S";
            label = "%time%  %date%";
          };
          "module/i3" = {
            type = "internal/i3";
            pin-workspaces = true;
            show-urgent = true;
            strip-wsnumbers = true;
            index-sort = true;
            enable-click = true;
            enable-scroll = false;
            fuzzy-match = true;

            ws-icon = [
              "code;"
              "terminal;"
              "web;爵"
              "comm;聆"
            ];
            ws-icon-default = "";
          };
          "module/audio" = {
            type = "internal/pulseaudio";
          };
        };
      };
    };
  };
}
