{config, ...}: let
  cfg = config.myConfig;
in {
  home-manager = {
    users.${cfg.username} = {};
    useGlobalPkgs = true;
    sharedModules = [
      {
        _file = ./.;
        myConfig = cfg;
      }
    ];
  };
}
