final: prev: {
  apple-cursor = final.callPackage ./apple-cursor.nix {};
  xremap = final.callPackage ./xremap.nix {};
  supersonic =
    if prev.stdenv.isDarwin
    then prev.supersonic
    else
      final.writeShellScriptBin "supersonic" ''
        FYNE_SCALE=2 ${prev.supersonic}/bin/supersonic
      '';
  i3-focus-last = final.callPackage ./i3-focus-last.nix {};
  fcitx5-fluent-dark = final.callPackage ./fcitx5-fluent-dark {};
  rime-dict = final.callPackage ./rime-dict.nix {};
  flake-repl = final.callPackage ./flake-repl {};
  cloudflare-utils = final.callPackage ./cloudflare-utils.nix {};

  flameshot = prev.flameshot.overrideAttrs (old: {
    patches = old.patches ++ [./patches/flameshot.patch];
  });

  gimpPlugins =
    prev.gimpPlugins
    // {
      resynthesizer = prev.gimpPlugins.resynthesizer.overrideAttrs (old: {
        src = prev.fetchFromGitHub {
          owner = "itr-tert";
          repo = "gimp-resynthesizer-scm";
          rev = "c44500b86e298433c32b0a4b05caf63b8811f959";
          sha256 = "sha256-Zc1wJaT7a9GCa6EaoyAwXaHk59lYYwrEHY1KGbPu6ic=";
        };
        meta = {broken = false;};
      });
    };

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
}
