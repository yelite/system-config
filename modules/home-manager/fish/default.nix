{ config, pkgs, lib, ... }:
let
  cfg = config.myHomeConfig.fish;
  inherit (lib) mkIf mkEnableOption;
in
{
  options = {
    myHomeConfig.fish = {
      enable = mkEnableOption "fish";
    };
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellAliases = {
        "ls" = "exa";
        # Steal the name from macOS
        "pbcopy" = "xclip -i -rmlastnl -selection c";
        "pbpaste" = "xclip -o -selection c";
      };
      plugins = pkgs.myFishPlugins;
      shellInit = builtins.readFile ./config.fish;
    };
  };
}
