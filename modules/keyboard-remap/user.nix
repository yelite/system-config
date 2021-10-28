{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    xkeysnail
  ];

  systemd.user.services.xkeysnail = {
    Unit = {
      Description = "xkeysnail-mac-remap";
    };
    Service = {
      Type = "simple";
      ExecStart = "/run/wrappers/bin/doas -n ${pkgs.xkeysnail}/bin/xkeysnail -q ${./config.py}";
      Restart = "on-failure";
      RestartSec = 4;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
