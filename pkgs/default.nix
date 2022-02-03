{ inputs }:

final: prev: {
  apple-cursor = prev.callPackage ./apple-cursor.nix { };
  neovide = prev.callPackage ./neovide.nix { inherit (prev) neovide; };
  xremap = prev.callPackage ./xremap.nix { };
}
