{ inputs }:

final: prev: {
  apple-cursor = prev.callPackage ./apple-cursor.nix { };
  neovide = import ./neovide.nix { pkgs = prev; };
}
