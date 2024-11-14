{
  inputs,
  lib,
  hostPlatform,
  ...
}: {
  system.configurationRevision = inputs.self.shortRev or "dirty";

  nix = {
    optimise.automatic = true;

    settings = {
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
    };

    extraOptions = ''
      extra-experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    gc =
      {
        automatic = true;
        options = "--delete-older-than 7d";
      }
      // lib.optionalAttrs hostPlatform.isDarwin {
        interval = {Day = 7;};
      }
      // lib.optionalAttrs hostPlatform.isLinux {
        dates = "weekly";
      };

    registry = {
      self.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
    };

    nixPath = ["/etc/nix/inputs"];
  };

  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/inputs/${name}";
      value = {source = value.outPath;};
    })
    inputs;
}
