{ config, pkgs, ... }:

let myConfig = config.myConfig;
in
{
  myConfig.homeManagerConfig = {
    neovim.enable = true;
    kitty.enable = true;
  };
}
