{
  config,
  lib,
  ...
}: let
  cfg = config.myConfig.desktop.keyboardRemap;
  desktopCfg = config.myConfig.desktop;
  inherit (lib) mkIf mkMerge;
in {
  config = mkMerge [
    (mkIf cfg.enable {
      myConfig.uinputGroup.enable = lib.mkForce true;
    })

    (mkIf (cfg.enable && desktopCfg.wayland.enable) {
      users.users.${config.myConfig.username} = {
        # TODO: Can we avoid having uinput group on user? Maybe use socat to proxy hyprland socket?
        extraGroups = ["uinput" "input"];
      };
      home-manager.sharedModules = [
        ({pkgs, ...}: {
          _file = ./default.nix;
          systemd.user.services.xremap-wlroots = mkIf desktopCfg.wayland.enable {
            Unit = {
              Description = "xremap-wlroots";
              PartOf = ["niri.service"];
              Conflicts = ["hm-graphical-session.target"];
            };
            Service = {
              Type = "simple";
              # Hack to wait for the hyprland socket to be ready
              ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
              ExecStart = "${pkgs.xremap}/bin/xremap --watch --ignore 'LogiOps Virtual Input' ${./config.yml}";
            };
            Install = {
              WantedBy = ["niri.service"];
            };
          };
        })
      ];
    })
  ];
}
