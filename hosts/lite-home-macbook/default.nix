{config, ...}: let
  myConfig = config.myConfig;
in {
  # TODO: move builder to home server
  nix.linux-builder.enable = true;
  nix.settings.trusted-users = [myConfig.username];

  myConfig.homeManagerConfig = {
    neovim.enable = true;
    kitty.enable = true;
    fish.enable = true;
    syncthing.enable = true;
  };
}
