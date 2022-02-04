{ inputs }:

final: prev: {
  apple-cursor = prev.callPackage ./apple-cursor.nix { };
  neovide = prev.callPackage ./neovide.nix { inherit (prev) neovide; };
  xremap = prev.callPackage ./xremap.nix { };
  alsa-lib = prev.alsa-lib.overrideAttrs (prev: {
    patches = [
      # This is a workaround for the alsa bug before
      # https://github.com/NixOS/nixpkgs/pull/157631 landing in unstable
      ./alsa.patch
    ];
  });
}
