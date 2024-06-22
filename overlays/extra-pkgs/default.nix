final: prev: {
  apple-cursor = final.callPackage ./apple-cursor.nix {};
  xremap = final.callPackage ./xremap.nix {};
  supersonic = final.writeShellScriptBin "supersonic" ''
    FYNE_SCALE=2 ${prev.supersonic}/bin/supersonic
  '';
  i3-focus-last = final.callPackage ./i3-focus-last.nix {};
  fcitx5-fluent-dark = final.callPackage ./fcitx5-fluent-dark {};
  rime-dict = final.callPackage ./rime-dict.nix {};
  flake-repl = final.callPackage ./flake-repl {};

  flameshot = prev.flameshot.overrideAttrs (old: {
    patches = old.patches ++ [./patches/flameshot.patch];
  });

  vtsls = final.buildNpmPackage {
    pname = "vtsls";
    version = "0.2.4";
    src = ./vtsls-wrapper;
    npmDepsHash = "sha256-TrrN+tPZILaxjboOEUEgCpadyKvgeBIIPGE+WOyk3Ro=";
    dontNpmBuild = true;
  };

  firefox-devedition-bin =
    if prev.stdenv.isDarwin
    then final.callPackage ./firefox-devedition-darwin.nix {}
    else prev.firefox-devedition-bin;

  # TODO: Remove after https://github.com/NixOS/nixpkgs/pull/305081 is resolved
  albert = prev.albert.overrideAttrs (old: {
    version = "0.22.17";

    src = final.fetchFromGitHub {
      owner = "albertlauncher";
      repo = "albert";
      rev = "v0.22.17";
      sha256 = "sha256-2wu4bOQDKoZ4DDzTttXXRNDluvuJth7M1pCvJmYQ+f4=";
      fetchSubmodules = true;
    };
  });
}
