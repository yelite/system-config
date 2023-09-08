{ pkgs, lib, ... }:
let
  session_start_cmd = "systemd-cat -t i3 startx ~/.xsession-hm";
  # TODO: Reevaluate wayland
  # session_start_cmd = "~/hyprland.sh";
  # Content:
  # export WLR_NO_HARDWARE_CURSORS=1
  # systemd-cat -t hyprland Hyprland
in
{
  services = {
    xserver = {
      displayManager = {
        startx.enable = true;
      };
    };

    greetd = {
      enable = true;
      vt = 2; # To avoid kernel logging. See https://github.com/apognu/tuigreet/issues/17
      settings = {
        default_session = {
          command = lib.concatStringsSep " " [
            "${pkgs.greetd.tuigreet}/bin/tuigreet"
            "--asterisks"
            "--remember"
            ''--cmd "${session_start_cmd}"''
          ];
        };
      };
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;

  # To avoid kernel logging on greetd tty. See https://github.com/apognu/tuigreet/issues/17
  boot.kernelParams = [ "console=tty1" ];
}
