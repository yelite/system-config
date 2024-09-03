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
      manager.prepend_keymap = [
        {
          on = ["<Enter>"];
          run = "enter";
          desc = "Enter the child directory";
        }
      ];
    };
  };

  xdg.configFile = {
    "yazi/theme.toml" = {
      source = ./theme.toml;
    };
  };
}
