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
      config = import ./config.nix { inherit cfg pkgs; };
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
          };
          icons = "material-nf";
          blocks = [
            {
              block = "music";
              format = "{ $icon  $combo.str(max_w:35) $play |}";
            }
            {
              block = "sound";
              show_volume_when_muted = true;
              max_vol = 100;
              format = " $icon {$volume.eng(w:3) |}";
            }
            {
              block = "disk_space";
              info_type = "available";
              interval = 60;
              alert = 5.0;
              warning = 10.0;
            }
            {
              block = "cpu";
              format = " $icon ";
              format_alt = " $icon $utilization.eng(w:2) ";
              interval = 2;
            }
            {
              block = "memory";
              format = " $icon ";
              format_alt = " $icon $mem_used_percents.eng(w:2) ";
            }
            {
              block = "temperature";
              format = " $icon $max ";
              format_alt = " $icon $min min, $average avg, $max max ";
              good = 0;
              idle = 68;
              info = 75;
              warning = 81;

              interval = 30;
            }
            {
              block = "tea_timer";
              format = " $icon {$minutes:$seconds |}";
              done_cmd = "notify-send 'Timer Finished'";
            }
            {
              block = "time";
              format = " $icon $timestamp.datetime(f:'%a %F %R') ";
              interval = 60;
            }
          ];
        };
      };
    };

    services = {
      screen-locker = {
        enable = true;
        lockCmd = "${i3lock-run}/bin/i3lock-run";
        inactiveInterval = 10;
      };
    };
  };
}
