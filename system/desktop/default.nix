{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.myConfig.desktop;
  inherit (lib) mkIf;
in {
  imports = [
    ./fonts.nix
    ./keyboard-remap
    ./logitech
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.helvum
    ];

    services = {
      geoclue2.enable = true;

      pipewire = {
        enable = true;
        wireplumber.enable = true;
        pulse.enable = true;
        alsa.enable = true;
        jack.enable = true;
      };

      gnome.gnome-keyring = {
        enable = true;
      };
      # conflict with ssh.startAgent
      gnome.gcr-ssh-agent.enable = lib.mkForce false;

      xserver = mkIf cfg.xserver.enable {
        enable = true;
        displayManager = {
          startx.enable = true;
        };
        wacom.enable = true;
      };

      libinput = {
        enable = true;
        mouse.accelProfile = "flat";
        mouse.middleEmulation = false;
      };

      greetd = {
        enable = true;
        # https://github.com/NixOS/nixpkgs/pull/428972 forces VT-1
        # vt = 2; # To avoid kernel logging. See https://github.com/apognu/tuigreet/issues/17
        settings = {
          default_session = {
            command = lib.concatStringsSep " " ([
                "${pkgs.greetd.tuigreet}/bin/tuigreet"
                "--asterisks"
                "--remember"
                ''--cmd "systemd-cat -t i3 startx ~/.xsession-hm"''
              ]
              ++ lib.optionals cfg.wayland.enable [
                "--sessions"
                # TODO: this should be consistent with home manager's program.niri.package.
                "${pkgs.niri}/share/wayland-sessions"
              ]);
          };
        };
      };
    };

    programs = {
      seahorse.enable = true;
    };

    # https://github.com/NixOS/nixpkgs/issues/401891
    security.pam.services.swaylock.enable = true;
    security.pam.services.i3lock.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;

    # To avoid kernel logging on greetd tty. See https://github.com/apognu/tuigreet/issues/17
    boot.kernelParams = ["console=tty1"];

    xdg.portal = {
      enable = true;
      # This is added based on the warning message from the new xdg portal impl
      # TODO: figure out how to configure this properly
      config.common.default = "*";
    };

    # TODO: for kde connect, move this to other place
    programs.kdeconnect = {
      enable = true;
    };
  };
}
