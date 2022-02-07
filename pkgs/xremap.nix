{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "xremap";
  version = "git";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = pname;
    rev = "9e4d5803a4afd7a1e0528904d450c42df0ad5d8c";
    sha256 = "sha256-EDbKdNHfrQAnzMkFl9txCCIPwCxmTj3LEUTRC8xeDjU=";
  };

  cargoSha256 = "sha256-osOrvbPlc1g6NJ8LgMcfrBkzX2fVS8XU9tjMQPd6nHU=";

  buildFeatures = [ "x11" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    xorg.libX11
  ];

  meta = with lib; {
    description = "Dynamic key remapper for X11 and Wayland";
    homepage = "https://github.com/k0kubun/xremap";
  };
}
