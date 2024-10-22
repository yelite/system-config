final: prev:
{
  apple-cursor = final.callPackage ./apple-cursor.nix {};
  xremap = final.callPackage ./xremap.nix {};
  i3-focus-last = final.callPackage ./i3-focus-last.nix {};
  fcitx5-fluent-dark = final.callPackage ./fcitx5-fluent-dark {};
  rime-dict = final.callPackage ./rime-dict.nix {};
  flake-repl = final.callPackage ./flake-repl {};
  cloudflare-utils = final.callPackage ./cloudflare-utils.nix {};
  discord-smtp-server = final.callPackage ./discord-smtp-server.nix {};

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

  supersonic =
    if prev.stdenv.isDarwin
    then
      prev.supersonic.overrideAttrs (old: {
        postPhases = (old.postPhases or []) ++ ["patchMacOSBundleIconPhase"];
        patchMacOSBundleIconPhase = let
          iconFile = prev.fetchurl {
            url = "https://raw.githubusercontent.com/yelite/supersonic/fix-macos-icon/res/appicon-macos.icns";
            sha256 = "sha256-WKIF1jfk4xVHV7p19nKUJJu6qohmHvWOKSy0YxY+5vE=";
          };
        in ''
          cp ${iconFile} $out/Applications/Supersonic.app/Contents/Resources/supersonic.icns
        '';
      })
    else
      final.writeShellScriptBin "supersonic" ''
        FYNE_SCALE=2 ${prev.supersonic}/bin/supersonic
      '';
}
// prev.lib.optionalAttrs prev.stdenv.isDarwin {
  # TODO: remove after https://github.com/NixOS/nixpkgs/pull/338070 is in unstable
  kitty = prev.kitty.overrideAttrs (old: {
    doChek = false;
    doInstallCheck = false;
    patches = old.patches ++ [./patches/kitty-darwin.patch];
    preCheck = ''
      # theme collection test starts an http server
      rm tools/themes/collection_test.go
      # passwd_test tries to exec /usr/bin/dscl
      rm tools/utils/passwd_test.go
    '';
  });
  hammerspoon = final.callPackage ./hammerspoon.nix {};
}
