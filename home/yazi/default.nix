{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      preview = {
        max_width = 800;
        max_height = 800;
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = ["<Enter>"];
          run = "enter";
          desc = "Enter the child directory";
        }
        {
          on = ["T"];
          run = "plugin --sync max-preview";
          desc = "Maximize or restore preview";
        }
        {
          on = ["<C-t>"];
          run = "plugin --sync hide-preview";
          desc = "Hide or restore preview";
        }
      ];
    };
    plugins = {
      max-preview = ./plugins/max-preview.yazi;
      hide-preview = ./plugins/hide-preview.yazi;
    };
  };

  programs.fish.shellAliases = {
    "yz" = "yazi";
  };

  xdg.configFile = {
    "yazi/theme.toml" = {
      source = ./theme.toml;
    };
  };
}
