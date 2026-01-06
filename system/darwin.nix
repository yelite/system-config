{
  config,
  pkgs,
  inputs,
  ...
}: let
  myConfig = config.myConfig;
  system-rebuild = pkgs.writeShellScriptBin "system-rebuild" ''
    darwin-rebuild --flake ~/.system-config "$@"
  '';
in {
  imports = [
    inputs.mac-app-util.darwinModules.default
  ];

  config = {
    environment = {
      shells = [pkgs.fish];
      systemPackages = [
        system-rebuild
      ];
    };

    programs = {
      fish.enable = true;
      # TODO: clean up after https://github.com/nix-community/home-manager/issues/8435 is resolved
      fish.useBabelfish = true;
    };

    users.users.${myConfig.username} = {
      # This is unmanaged user from nix-darwin perspective
      # But setting home is still necessary for home manager to
      # find the home directory.
      home = "/Users/${myConfig.username}";
    };

    system.primaryUser = myConfig.username;

    system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = -1.0;
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToControl = true;
    system.defaults.WindowManager.GloballyEnabled = true;
    system.defaults.dock.mru-spaces = false;

    home-manager.sharedModules = [
      inputs.mac-app-util.homeManagerModules.default
    ];

    nixpkgs.flake.setFlakeRegistry = false;
    nixpkgs.flake.setNixPath = false;

    system.stateVersion = 6;
  };
}
