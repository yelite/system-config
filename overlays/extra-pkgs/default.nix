final: prev: {
  apple-cursor = final.callPackage ./apple-cursor.nix {};
  xremap = final.callPackage ./xremap.nix {};
  goimports-reviser = final.callPackage ./goimports-reviser.nix {};
  supersonic = final.callPackage ./supersonic.nix {};
  fyne = final.callPackage ./fyne.nix {};
  i3-focus-last = final.callPackage ./i3-focus-last.nix {};
  fcitx5-fluent-dark = final.callPackage ./fcitx5-fluent-dark {};
  rime-dict = final.callPackage ./rime-dict.nix {};
  flake-repl = final.callPackage ./flake-repl {};

  flameshot = prev.flameshot.overrideAttrs (old: {
    patches = old.patches ++ [./patches/flameshot.patch];
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
    patches = [./patches/logiops.patch];
    buildInputs = old.buildInputs ++ [final.glib];
  });

  vivaldi =
    (prev.vivaldi.override {
      commandLineArgs = [
        "--force-dark-mode" # Make prefers-color-scheme selector to choose dark theme
        # TODO: experiment this with newer driver to see if screen flickering still presists
        # "--disable-gpu-sandbox"
      ];
      enableWidevine = true;
      widevine-cdm = final.widevine-cdm;
    })
    .overrideAttrs (old: rec {
      # TODO: leave here when reevaluate wayland
      # version = "6.0.2979.25";
      # suffix = "amd64";
      # src = final.fetchurl {
      #   url = "https://downloads.vivaldi.com/stable/vivaldi-stable_${version}-1_${suffix}.deb";
      #   hash = "sha256-m3N7dvOtRna3FYLZdkPjAfGRF4KAJ8XlDlpGnToAwVY=";
      # };
    });

  vtsls = final.buildNpmPackage {
    pname = "vtsls";
    version = "0.2.0";
    src = ./vtsls-wrapper;
    npmDepsHash = "sha256-d7eb7cYAu637d0+xsKtumgIUAIqWg9q+ikRs2yGrmuc=";
    dontNpmBuild = true;
  };

  vimPlugins =
    prev.vimPlugins
    // {
      nvim-cmp = prev.vimPlugins.nvim-cmp.overrideAttrs (old: {
        # TODO: remove after https://github.com/hrsh7th/nvim-cmp/pull/1725 is merged
        patches = [./patches/nvim-cmp.patch];
      });
    };
}
