{ pkgs, ... }:
let lib = pkgs.lib;
in
pkgs.neovide.overrideAttrs (prev: rec {
  version = "git";
  src = pkgs.fetchFromGitHub {
    owner = "yelite";
    repo = "neovide";
    rev = "f545a1ef389e8766f94dd84697a54ab68002832f";
    sha256 = "sha256-h4Eu6Xf15ootpYmaJy+MkIrjdHJiS/sCsT32S0Jag90=";
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
    outputHash = "sha256-ndCsA9cPu0TutG7Aq44GT7Tynk208fN0gI546Cn912Q=";
  });
})
