final: prev:
{
  apple-cursor = prev.callPackage ./apple-cursor.nix { };
  xremap = prev.callPackage ./xremap.nix { };
  goimports-reviser = prev.callPackage ./goimports-reviser.nix { };
  supersonic = prev.callPackage ./supersonic.nix { };
  i3-focus-last = prev.callPackage ./i3-focus-last.nix { };
  fcitx5-fluent-dark = prev.callPackage ./fcitx5-fluent-dark { };
  rime-dict = prev.callPackage ./rime-dict.nix { };
  flake-repl = prev.callPackage ./flake-repl { };

  flameshot = prev.flameshot.overrideAttrs (old: {
    patches = old.patches ++ [ ./patches/flameshot.patch ];
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
    patches = [ ./patches/logiops.patch ];
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
