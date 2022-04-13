{ config, pkgs, lib, inputs, ... }:
let
  cfg = config.myHomeConfig.fish;
  inherit (lib) mkIf mkEnableOption mkOption;
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
      };
      plugins = inputs.fish-plugins.extraFishPlugins;
      shellInit = builtins.readFile ./config.fish;
    };
  };
}
