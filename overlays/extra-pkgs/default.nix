final: prev:
{
  apple-cursor = prev.callPackage ./apple-cursor.nix { };
  xremap = prev.callPackage ./xremap.nix { };
  goimports-reviser = prev.callPackage ./goimports-reviser.nix { };
  supersonic = prev.callPackage ./supersonic.nix { };
  i3-focus-last = prev.callPackage ./i3-focus-last.nix { };

  # rename the script of fup-repl from flake-utils-plus 
  my-fup-repl = final.fup-repl.overrideAttrs (old: {
    buildCommand = old.buildCommand + ''
      mv $out/bin/repl $out/bin/fup-repl
    '';
  });

  flameshot = prev.flameshot.overrideAttrs (old: {
    patches = old.patches ++ [ ./flameshot.patch ];
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

  logiops = prev.logiops.overrideAttrs (old: {
    version = "0.3.3";
    src = final.fetchFromGitHub {
      owner = "pixlone";
      repo = "logiops";
      rev = "v0.3.3";
      sha256 = "sha256-9nFTud5szQN8jpG0e/Bkp+I9ELldfo66SdfVCUTuekg=";
      fetchSubmodules = true;
    };
    patches = [ ./logiops.patch ];
    buildInputs = old.buildInputs ++ [ final.glib ];
  });

  vivaldi = (prev.vivaldi.override {
    commandLineArgs = [
      "--force-dark-mode" # Make prefers-color-scheme selector to choose dark theme
      # TODO: experiment this with newer driver to see if screen flickering still presists
      # "--disable-gpu-sandbox"
    ];
    enableWidevine = true;
    widevine-cdm = final.widevine-cdm;
  }).overrideAttrs (old: rec {
    # TODO: leave here when reevaluate wayland
    # version = "6.0.2979.25";
    # suffix = "amd64";
    # src = final.fetchurl {
    #   url = "https://downloads.vivaldi.com/stable/vivaldi-stable_${version}-1_${suffix}.deb";
    #   hash = "sha256-m3N7dvOtRna3FYLZdkPjAfGRF4KAJ8XlDlpGnToAwVY=";
    # };
  });
}
