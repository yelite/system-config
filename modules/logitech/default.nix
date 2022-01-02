{ config, pkgs, lib, ... }:
let
  logiops = pkgs.callPackage ./package.nix { };
  cfg = config.myConfig.logitech;
  inherit (lib) mkIf mkEnableOption;
in
{
  options = {
    myConfig.logitech = {
      enable = mkEnableOption "logitech";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.solaar # tool for the unify receiver
    ];

    users.users.logiops = {
      isSystemUser = true;
      group = "logiops";
      extraGroups = [ "hidraw" ];
    };
    users.groups.logiops = { };
    users.groups.hidraw = { };

    # Taken from https://github.com/NixOS/nixpkgs/pull/124158#discussion_r716201439
    services.udev.extraRules = '' 
    KERNEL=="uinput", GROUP="hidraw", MODE:="0660", OPTIONS+="static_node=uinput" 
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0660", GROUP="hidraw" 
  '';

    systemd.services.logiops = {
      description = "Logitech Configuration Daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${logiops}/bin/logid -c ${./logiops.cfg}";
        User = "logiops";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
        RestartSec = 3;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
