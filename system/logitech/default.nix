{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myConfig.logitech;
  inherit (lib) mkIf mkEnableOption;
in {
  options = {
    myConfig.logitech = {
      enable = mkEnableOption "logitech";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.solaar # tool for the unify receiver
      pkgs.logiops
    ];

    users.users.logiops = {
      isSystemUser = true;
      group = "logiops";
      extraGroups = ["uinput"];
    };
    users.groups.logiops = {};
    myConfig.uinput.enableGroup = lib.mkForce true;

    # Taken from https://github.com/NixOS/nixpkgs/pull/124158#discussion_r716201439
    services.udev.extraRules = ''
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0660", GROUP="logiops"
    '';

    services.dbus.packages = [
      (pkgs.writeTextFile
        {
          name = "logiops-dbus-conf";
          destination = "/share/dbus-1/system.d/pizza.pixl.LogiOps.conf";
          text = builtins.readFile ./logiops-dbus.conf;
        })
    ];

    systemd.services.logiops = {
      description = "Logitech Configuration Daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.logiops}/bin/logid -c ${./logiops.cfg}";
        User = "logiops";
        Restart = "on-abort";
        RestartSec = 3;
      };
      wantedBy = ["graphical.target"];
    };
  };
}
