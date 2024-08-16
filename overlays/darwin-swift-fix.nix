# To fix the swift build failure https://github.com/NixOS/nixpkgs/issues/327836
darwin-nixpkgs-input: (final: prev: let
  darwin-nixpkgs = import darwin-nixpkgs-input {inherit (prev) system;};
in
  prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
    inherit (darwin-nixpkgs) swift;
  })
