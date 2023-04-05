{ config, pkgs, lib, hostPlatform, ... }:
let
  cfg = config.myConfig.keyboardRemap;
  inherit (lib) mkIf mkEnableOption;
  homeModule = { pkgs, ... }:
    {
      systemd.user.services.xremap = {
        Unit = {
          Description = "xremap-mac-remap";
        };
        Service = {
          Type = "simple";
          ExecStartPre = "${pkgs.xorg.xhost}/bin/xhost +SI:localuser:xremap";
          ExecStart = "/run/wrappers/bin/doas -u xremap -n ${pkgs.xremap}/bin/xremap --watch ${./config.yml}";
          Restart = "on-failure";
          RestartSec = 4;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
in
lib.optionalAttrs hostPlatform.isLinux {
  options = {
    myConfig.keyboardRemap = {
      enable = mkEnableOption "keyboardRemap";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xremap
    ];

    users.users.xremap = {
      isSystemUser = true;
      group = "xremap";
      extraGroups = [ "uinput" "input" ];
    };
    users.groups.xremap = { };
    myConfig.uinput.enableGroup = lib.mkForce true;

    security.doas.extraRules = lib.mkAfter [
      {
        users = [ config.myConfig.username ];
        runAs = "xremap";
        noPass = true;
        keepEnv = true;
        cmd = "${pkgs.xremap}/bin/xremap";
        args = [
          "--watch"
          "${./config.yml}"
        ];
      }
    ];
    myConfig.homeManagerModules = [ homeModule ];
  };
}
