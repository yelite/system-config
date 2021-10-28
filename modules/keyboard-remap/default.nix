{ config, pkgs, ... }:

{
  security.doas.extraRules = pkgs.lib.mkAfter [
    {
      users = [ "liteye" ];
      noPass = true;
      keepEnv = true;
      cmd = "${pkgs.xkeysnail}/bin/xkeysnail";
      args = [
        "-q"
        "${./config.py}"
      ];
    }
  ];
}
