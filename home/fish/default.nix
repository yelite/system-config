{
  config,
  pkgs,
  lib,
  hostPlatform,
  ...
}:
lib.mkIf config.myConfig.fish.enable {
  programs.fish = {
    enable = true;
    shellAliases =
      {
        "ls" = "eza";
        "cat" = "bat";
      }
      // lib.optionalAttrs hostPlatform.isLinux {
        # Steal the name from macOS
        "pbcopy" = "xclip -i -rmlastnl -selection c";
        "pbpaste" = "xclip -o -selection c";
      };
    plugins = pkgs.myFishPlugins;
    interactiveShellInit = builtins.readFile ./config.fish;
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
        ''''${env_var.shpool}''
        "$sudo"
        "$cmd_duration"
        "$line_break"
        "$jobs"
        "$character"
      ];

      # Always show username and hostname in a shpool session, which almost always happens on servers.
      # The shpool session won't get SSH_CONNECTION env var so the regular ssh check will fail.
      username = {
        detect_env_vars = ["SHPOOL_SESSION_NAME" "SSH_CONNECTION"];
      };
      hostname = {
        ssh_only = false;
        detect_env_vars = ["SHPOOL_SESSION_NAME" "SSH_CONNECTION"];
      };
      git_commit = {
        disabled = true;
      };
      env_var = {
        shpool = {
          symbol = "󱗃 ";
          variable = "SHPOOL_SESSION_NAME";
          style = "fg:214";
          format = "with [$symbol$env_value]($style) ";
        };
      };
    };
  };

  xdg.configFile."bat/config".source =
    pkgs.writeText "bat_config"
    ''
      --theme="ansi"
    '';
}
