{
  inputs,
  lib,
  hostPlatform,
  ...
}: {
  imports =
    lib.optionals hostPlatform.isLinux [
      ./nixos.nix
      ./nfs.nix
    ]
    ++ lib.optionals hostPlatform.isDarwin [
      ./darwin.nix
    ];

  config = {
    system.configurationRevision = inputs.self.shortRev or "dirty";

    nix = {
      extraOptions = ''
        extra-experimental-features = nix-command flakes
        keep-outputs = true
        keep-derivations = true
      '';

      settings.auto-optimise-store = true;

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
  };
}
