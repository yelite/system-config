{ config, pkgs, lib, hostPlatform, ... }:
let
  cfg = config.myConfig.keyboardRemap;
  displayCfg = config.myConfig.display;
  inherit (lib) mkIf mkEnableOption mkMerge;
  xremap-x11 = pkgs.xremap.override { enableX11 = true; };
  xremap-hypr = pkgs.xremap.override { enableHypr = true; };
in
lib.optionalAttrs hostPlatform.isLinux {
  options = {
    myConfig.keyboardRemap = {
      enable = mkEnableOption "keyboardRemap";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      myConfig.uinput.enableGroup = lib.mkForce true;
    })

    (mkIf (cfg.enable && displayCfg.wayland.enable) {
      users.users.${ config.myConfig.username } = {
        # TODO: Can we avoid having uinput group on user? Maybe use socat to proxy hyprland socket?
        extraGroups = [ "uinput" "input" ];
      };
      myConfig.homeManagerModules = [
        ({ pkgs, ... }:
          {
            systemd.user.services.xremap-hypr = mkIf displayCfg.wayland.enable {
              Unit = {
                Description = "xremap-hypr";
                PartOf = [ "hyprland-session.target" ];
                Conflicts = [ "hm-graphical-session.target" ];
              };
              Service = {
                Type = "simple";
                # Hack to wait for the hyprland socket to be ready
                ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
                ExecStart = "${xremap-hypr}/bin/xremap --watch ${./config.yml}";
              };
              Install = {
                WantedBy = [ "hyprland-session.target" ];
              };
            };
          })
      ];
    })

    (mkIf (cfg.enable && displayCfg.xserver.enable) {
      users.users.xremap = {
        isSystemUser = true;
        group = "xremap";
        extraGroups = [ "uinput" "input" "hypr" ];
      };
      users.groups.xremap = { };
      security.doas.extraRules = lib.mkAfter [
        {
          users = [ config.myConfig.username ];
          runAs = "xremap";
          noPass = true;
          keepEnv = true;
          cmd = "${xremap-x11}/bin/xremap";
          args = [
            "--watch"
            "${./config.yml}"
          ];
        }
      ];
      myConfig.homeManagerModules = [
        ({ pkgs, ... }:
          {
            systemd.user.services.xremap-x11 = mkIf displayCfg.xserver.enable {
              Unit = {
                Description = "xremap-x11";
                PartOf = [ "hm-graphical-session.target" ];
                Conflicts = [ "hyprland-session.target" ];
              };
              Service = {
                Type = "simple";
                ExecStartPre = "${pkgs.xorg.xhost}/bin/xhost +SI:localuser:xremap";
                ExecStart = "/run/wrappers/bin/doas -u xremap -n ${xremap-x11}/bin/xremap --watch ${./config.yml}";
              };
              Install = {
                WantedBy = [ "hm-graphical-session.target" ];
              };
            };
          })
      ];
    })
  ];
}
