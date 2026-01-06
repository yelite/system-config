{
  inputs,
  lib,
  options,
  hostPlatform,
  ...
}: let
  # Detect if Determinate Nix module is imported by checking for its options
  hasDeterminate = options ? "determinate-nix";
  hasDeterminateDarwin = hasDeterminate && hostPlatform.isDarwin;

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
in {
  config =
    {
      system.configurationRevision = inputs.self.shortRev or "dirty";

      # Standard nix configuration when not using Determinate Nix,
      # or on NixOS where we can still configure nix settings alongside the module
      nix = {
        # TODO: use mkMerge to simplify logic
        enable = lib.mkIf hasDeterminateDarwin false;

        optimise.automatic = lib.mkIf (!hasDeterminateDarwin) true;

        settings = {
          inherit substituters trusted-public-keys;
        };

        extraOptions = ''
          extra-experimental-features = nix-command flakes
          keep-outputs = true
          keep-derivations = true
        '';

        gc = lib.mkIf (!hasDeterminateDarwin) (
          {
            automatic = true;
            options = "--delete-older-than 7d";
          }
          // lib.optionalAttrs hostPlatform.isDarwin {
            interval = {Day = 7;};
          }
          // lib.optionalAttrs hostPlatform.isLinux {
            dates = "weekly";
          }
        );

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
    // lib.optionalAttrs hasDeterminateDarwin {
      # TODO: manually create service like https://github.com/nix-darwin/nix-darwin/blob/9f48ffaca1f44b3e590976b4da8666a9e86e6eb1/modules/services/nix-gc/default.nix
      determinate-nix.customSettings = {
        extra-trusted-public-keys = trusted-public-keys;
        extra-substituters = substituters;
        keep-outputs = true;
        keep-derivations = true;
      };
    };
}
