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

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_metrics"
          "$git_status"
          "$hg_branch"
          "$package"
          "$nix_shell"
          "$sudo"
          "$cmd_duration"
          "$line_break"
          "$jobs"
          "$character"
        ];
      };
    };

    xdg.configFile."bat/config".source = pkgs.writeText "bat_config"
      ''
        --theme="ansi"
      '';
  };
}
