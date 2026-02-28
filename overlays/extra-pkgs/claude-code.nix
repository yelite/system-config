{
  claude-code,
  fetchzip,
  fetchNpmDeps,
}:
claude-code.overrideAttrs (finalAttrs: previousAttrs: {
  version = "2.1.63";

  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${finalAttrs.version}.tgz";
    hash = "sha256-tVk1GXqh9Ice8ZbbLnmN4sSlIY41KsrqWi2eDo47/zI=";
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
