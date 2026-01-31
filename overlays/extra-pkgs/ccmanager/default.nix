{
  lib,
  bun2nix,
  fetchFromGitHub,
}:
bun2nix.mkDerivation {
  pname = "ccmanager";
  version = "3.6.4";

  src = fetchFromGitHub {
    owner = "kbwo";
    repo = "ccmanager";
    rev = "v3.6.4";
    hash = "sha256-uxzQtHQ5bGhoaR8o5SBfgM2oo80pZhsOB8936hezOh0=";
  };

  bunDeps = bun2nix.fetchBunDeps {
    bunNix = ./bun.nix;
  };

  module = "src/cli.tsx";

  # It has top-level await statement
  bunCompileToBytecode = false;

  meta = with lib; {
    description = "Session manager for multiple AI coding assistants";
    homepage = "https://github.com/kbwo/ccmanager";
    license = licenses.mit;
    mainProgram = "ccmanager";
  };
}
