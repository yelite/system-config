{
  inputs,
  lib,
  ...
}: {
  imports = [
    ./nixos.nix
    ./darwin.nix
    ./darwin-mouse.nix

    ./nfs.nix
  ];

  config = {
    system.configurationRevision = inputs.self.shortRev or "dirty";

    nix.extraOptions = ''
      extra-experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    nix.registry = {
      self.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
    };

    environment.etc =
      lib.mapAttrs'
      (name: value: {
        name = "nix/inputs/${name}";
        value = {source = value.outPath;};
      })
      inputs;

    nix.nixPath = ["/etc/nix/inputs"];
  };
}
