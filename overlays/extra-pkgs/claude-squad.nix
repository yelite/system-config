{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  git,
  tmux,
  gh,
}:
buildGoModule rec {
  pname = "claude-squad";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "smtg-ai";
    repo = "claude-squad";
    rev = "v${version}";
    hash = "sha256-zh4vhZMtKbNT3MxNr18Q/3XC0AecFf5tOYIRT1aFk38=";
  };

  vendorHash = "sha256-BduH6Vu+p5iFe1N5svZRsb9QuFlhf7usBjMsOtRn2nQ=";

  nativeBuildInputs = [makeWrapper];
  nativeCheckInputs = [git];

  # Skip tests that require writable home directory for git worktrees
  checkFlags = ["-skip" "TestPreviewScrolling|TestPreviewContentWithoutScrolling"];

  postInstall = ''
    wrapProgram $out/bin/claude-squad \
      --prefix PATH : ${lib.makeBinPath [git tmux gh]}
  '';

  meta = with lib; {
    description = "Terminal application to orchestrate multiple AI coding agents";
    homepage = "https://github.com/smtg-ai/claude-squad";
    license = licenses.agpl3Only;
    mainProgram = "claude-squad";
  };
}
