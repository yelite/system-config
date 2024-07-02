{
  config,
  lib,
  hostPlatform,
  ...
}:
lib.mkIf config.myConfig.syncthing.enable {
  services.syncthing = {
    enable = true;
    tray = {
      enable = hostPlatform.isLinux;
      command = "syncthingtray --wait";
    };
  };
}
