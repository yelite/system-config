{pkgs, ...}: {
  config = {
    home.packages = [
      pkgs.hammerspoon
    ];

    home.file.".hammerspoon/init.lua" = {
      source = ./init.lua;
      onChange = "hs -c 'hs.reload()' || true";
    };
  };
}
