final: prev:
{
  apple-cursor = final.callPackage ./apple-cursor.nix {};
  fcitx5-fluent-dark = final.callPackage ./fcitx5-fluent-dark {};
  rime-dict = final.callPackage ./rime-dict.nix {};
  flake-repl = final.callPackage ./flake-repl {};
  dcd = final.callPackage ./dcd.nix {};
  claude-code-notification = final.callPackage ./claude-code-notification.nix {};
  ccmanager = final.callPackage ./ccmanager {};

  flameshot = prev.flameshot.overrideAttrs (old: {
    patches = old.patches ++ [./patches/flameshot.patch];
  });

  claude-code = prev.claude-code.overrideAttrs (finalAttrs: previousAttrs: {
    version = "2.1.42";

    src = final.fetchzip {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${finalAttrs.version}.tgz";
      hash = "sha256-+99eaqKAOUvz+omHJ4bxlDepdpn8FNLmvxKcVDR76o4=";
    };
  });
}
// prev.lib.optionalAttrs prev.stdenv.isDarwin {
  hammerspoon = final.callPackage ./hammerspoon.nix {};
  firefox-devedition-bin = final.callPackage ./firefox-devedition-darwin.nix {};
}
