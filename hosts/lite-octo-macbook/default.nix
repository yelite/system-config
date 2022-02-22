{ config, pkgs, ... }:

let myConfig = config.myConfig;
in
{
  home-manager.sharedModules = [{
    myHomeConfig = {
      neovim.enable = true;
      kitty.enable = true;
    };
  }];
}
