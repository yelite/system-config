{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "claude-code-notification";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "wyattjoh";
    repo = "claude-code-notification";
    rev = "v${version}";
    hash = "sha256-1VJ3engMrhSG13B/LyYPf7jE10si20fEzCMk6TLouBo=";
  };

  cargoHash = "sha256-+6PeDcS7yLZFNHKrvq4QoC4RdvXVSeNOMaE0VunsXtc=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    dbus
  ];

  meta = with lib; {
    description = "A high-performance Rust CLI tool for displaying cross-platform desktop notifications for Claude Code";
    homepage = "https://github.com/wyattjoh/claude-code-notification";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "claude-code-notification";
    platforms = platforms.unix;
  };
}
