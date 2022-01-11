{ pkgs, ... }:
let lib = pkgs.lib;
in
pkgs.neovide.overrideAttrs (prev: rec {
  version = "git";
  src = pkgs.fetchFromGitHub {
    owner = "yelite";
    repo = "neovide";
    rev = "f14891ccb5e3e13ba2a4b42b3a83eead6ecf0f7b";
    sha256 = "sha256-xdhvza+yB3f0z+Gk7Ezm50NmDCz729IbOaJYcRY8J5Q=";
  };
  SKIA_SOURCE_DIR =
    let
      repo = pkgs.fetchFromGitHub {
        owner = "rust-skia";
        repo = "skia";
        # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
        rev = "m93-0.42.0";
        sha256 = "sha256-F1DWLm7bdKnuCu5tMMekxSyaGq8gPRNtZwcRVXJxjZQ=";
      };
      # The externals for skia are taken from skia/DEPS
      externals = lib.mapAttrs (n: v: pkgs.fetchgit v) (lib.importJSON ./skia-externals.json);
    in
    pkgs.runCommand "source" { } (
      ''
        cp -R ${repo} $out
        chmod -R +w $out
        mkdir -p $out/third_party/externals
        cd $out/third_party/externals
      '' + (builtins.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "cp -ra ${value} ${name}") externals))
    );
  cargoDeps = prev.cargoDeps.overrideAttrs (lib.const {
    name = "neovide-vendor.tar.gz";
    inherit src;
    outputHash = "sha256-LeqNdizPLUPd/Cviu/9+9weitqlM45aUL7ARPFEQoKs=";
  });
})
