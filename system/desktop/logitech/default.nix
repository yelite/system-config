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

    services.dbus.packages = [
      # For some reason this dbus config is needed to be part of services.dbus.packages
      # Otherwise logiops won't work in non-root user.
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
        ExecStart = "${pkgs.logiops}/bin/logid -c ${cfg.configFile}";
        User = "logiops";
        Restart = "on-abort";
        RestartSec = 3;
      };
      wantedBy = ["graphical.target"];
    };

    # Device will use the default config if logiops isn't restarted after sleeping
    # https://github.com/PixlOne/logiops/issues/129
    environment.etc."systemd/system-sleep/restart-logiops.sh".source = pkgs.writeShellScript "restart-logiops.sh" ''
      if [ "$1" = "post" ]; then
        echo "Restarting logiops service after wake up"
        systemctl restart logiops.service
      else
        echo "Not restarting logiops service. Received args: " $@
      fi
    '';
  };
}
