# Based on https://github.com/P1n3appl3/config/blob/726bd62f1068683b600d88815830fc019dc52c2f/modules/home/shpool.nix#L6
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myConfig.shpool;
  toml = pkgs.formats.toml {};
  configFilePath = toml.generate "config.toml" {
    keybinding = [
      {
        binding = "Ctrl-Esc Ctrl-Esc";
        action = "detach";
      }
    ];
  };
in {
  config = lib.mkIf cfg.enable {
    systemd.user = {
      services.shpool = {
        Unit = {
          Description = "Shell Session Pool";
          Requires = "shpool.socket";
        };
        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.shpool} -c ${configFilePath} daemon";
          KillMode = "mixed";
          TimeoutStopSec = "2s";
          SendSIGHUP = "yes";
        };
        Install.WantedBy = ["default.target"];
      };

      sockets.shpool = {
        Socket = {
          ListenStream = "%t/shpool/shpool.socket";
          SocketMode = "0600";
        };
        Install.WantedBy = ["sockets.target"];
      };
    };
  };
}
