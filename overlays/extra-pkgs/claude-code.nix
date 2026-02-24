{
  claude-code,
  fetchzip,
  fetchNpmDeps,
}:
claude-code.overrideAttrs (finalAttrs: previousAttrs: {
  version = "2.1.51";

  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${finalAttrs.version}.tgz";
    hash = "sha256-WY0f6oWAnw/0BA7/ITV5EMkD5unex9LBfPmnYi5ZcX8=";
  };

  postPatch = ''
    cp ${./claude-code-package-lock.json} ./package-lock.json
  '';

  npmDeps = fetchNpmDeps {
    src = finalAttrs.src;
    postPatch = ''
      cp ${./claude-code-package-lock.json} ./package-lock.json
    '';
    hash = "sha256-/oQxdQjMVS8r7e1DUPEjhWOLOD/hhVCx8gjEWb3ipZQ=";
  };
})
