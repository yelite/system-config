final: prev:
{
  apple-cursor = prev.callPackage ./apple-cursor.nix { };
  xremap = prev.callPackage ./xremap.nix { };
  goimports-reviser = prev.callPackage ./goimports-reviser.nix { };

  # rename the script of fup-repl from flake-utils-plus 
  my-fup-repl = final.fup-repl.overrideAttrs (old: {
    buildCommand = old.buildCommand + ''
      mv $out/bin/repl $out/bin/fup-repl
    '';
  });

  # Fix cover art and tray icon
  tauon = prev.tauon.overrideAttrs (old: {
    version = "head";
    src = final.fetchFromGitHub {
      owner = "Taiko2k";
      repo = "TauonMusicBox";
      rev = "f2d683228eeb420171cdde2a7ec0dfb50b376997";
      hash = "sha256-ibGv7IBjhqjyD+glPdBNtQiAXquRqG0eMqGIy58RH8g=";
    };

    buildInputs = old.buildInputs ++ [ final.libappindicator ];

    patches = [ ./tauon.patch ];
  });
}
