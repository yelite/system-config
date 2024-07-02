{config, ...}: let
  cfg = config.myConfig;
in {
  home-manager = {
    users.${cfg.username} = {
      _file = ./.;
      myConfig = cfg;
    };
    useGlobalPkgs = true;
  };
}
