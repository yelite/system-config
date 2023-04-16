{ config, pkgs, lib, hostPlatform, ... }:
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
        "cat" = "bat";
      } // lib.optionalAttrs hostPlatform.isLinux {
        # Steal the name from macOS
        "pbcopy" = "xclip -i -rmlastnl -selection c";
        "pbpaste" = "xclip -o -selection c";
      };
      plugins = pkgs.myFishPlugins;
      shellInit = builtins.readFile ./config.fish;
    };

    xdg.configFile."bat/config".source = pkgs.writeText "bat_config"
      ''
        --theme="ansi"
      '';
  };
}
