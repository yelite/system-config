{ config, ... }:

let myConfig = config.myConfig;
in
{
  myConfig.homeManagerConfig = {
    neovim.enable = true;
    kitty.enable = true;
    fish.enable = true;
  };
}
