{
  config,
  pkgs,
  inputs,
  ...
}: let
  myConfig = config.myConfig;
in {
  imports = [
    inputs.mac-app-util.darwinModules.default
  ];

  config = {
    environment = {
      shells = [pkgs.fish];
      shellAliases = {
        system-rebuild = "darwin-rebuild --flake ~/.system-config";
      };
    };

    nix.useDaemon = true;

    programs = {
      fish.enable = true;
    };

    users.users.${myConfig.username} = {
      # This is unmanaged user from nix-darwin perspective
      # But setting home is still necessary for home manager to
      # find the home directory.
      home = "/Users/${myConfig.username}";
    };

    system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = "-1";

    home-manager.sharedModules = [
      inputs.mac-app-util.homeManagerModules.default
    ];
  };
}
