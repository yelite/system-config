{ lib, neovide, fetchFromGitHub, fetchgit, runCommand, python310, makeWrapper }:
neovide.overrideAttrs (prev: rec {
  version = "git";
  src = fetchFromGitHub {
    owner = "neovide";
    repo = "neovide";
    rev = "6b45dca45332e1e46e48be225417525a7e258730";
    sha256 = "sha256-ZV5Ko35iVKePebSg6AAOL6b9ywgWgyeazLNsf7PCWog=";
  };
  SKIA_SOURCE_DIR =
    let
      repo = fetchFromGitHub {
        owner = "rust-skia";
        repo = "skia";
        # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
        rev = "m93-0.42.0";
        sha256 = "sha256-F1DWLm7bdKnuCu5tMMekxSyaGq8gPRNtZwcRVXJxjZQ=";
      };
      # The externals for skia are taken from skia/DEPS
      externals = lib.mapAttrs (n: v: fetchgit v) (lib.importJSON ./skia-externals.json);
    in
    runCommand "source" { } (
      ''
        cp -R ${repo} $out
        chmod -R +w $out
        mkdir -p $out/third_party/externals
        cd $out/third_party/externals
      '' + (builtins.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "cp -ra ${value} ${name}") externals))
    );

  nativeBuildInputs = prev.nativeBuildInputs ++ [ python310 makeWrapper ];

  postInstall = prev.postInstall + ''
    wrapProgram $out/bin/neovide --add-flags "--multigrid"
  '';

  cargoDeps = prev.cargoDeps.overrideAttrs (lib.const {
    name = "neovide-vendor.tar.gz";
    inherit src;
    outputHash = "sha256-tEQEfjig0HF0N3hi8tftBEURn1RksIFnFHjnKbBBRLs=";
  });
})
