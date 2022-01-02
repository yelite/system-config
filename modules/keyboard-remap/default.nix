let
  homeModule = { pkgs, ... }:
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
          ExecStart = "/run/wrappers/bin/doas -n ${pkgs.xkeysnail}/bin/xkeysnail --watch -q ${./config.py}";
          Restart = "on-failure";
          RestartSec = 4;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  nixosModule = { config, pkgs, lib, ... }:
    let
      cfg = config.myConfig.keyboardRemap;
      inherit (lib) mkIf mkEnableOption;
    in
    {
      options = {
        myConfig.keyboardRemap = {
          enable = mkEnableOption "keyboardRemap";
        };
      };

      config = mkIf cfg.enable {
        security.doas.extraRules = pkgs.lib.mkAfter [
          {
            users = [ config.myConfig.username ];
            noPass = true;
            keepEnv = true;
            cmd = "${pkgs.xkeysnail}/bin/xkeysnail";
            args = [
              "--watch"
              "-q"
              "${./config.py}"
            ];
          }
        ];

        myConfig.homeManagerModules = [ homeModule ];
      };
    };
in
nixosModule
