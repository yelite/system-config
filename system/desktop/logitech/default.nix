{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.desktop.logitech;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.solaar # tool for the unify receiver
      pkgs.logiops
    ];

    myConfig.uinputGroup.enable = lib.mkForce true;
    users.groups.logiops = {};
    users.users.logiops = {
      isSystemUser = true;
      group = "logiops";
      extraGroups = ["uinput"];
    };

    # Taken from https://github.com/NixOS/nixpkgs/pull/124158#discussion_r716201439
    services.udev.extraRules = ''
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0660", GROUP="logiops"
    '';

    systemd.services.logiops = {
      description = "Logitech Configuration Daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.logiops}/bin/logid -c ${cfg.configFile}";
        User = "logiops";
        Restart = "on-abort";
        RestartSec = 3;
      };
      wantedBy = ["graphical.target"];
    };
  };
}
