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
    rev = "4b8690b9171fcfc1815bf8eae784aa3ff6a81a93";
    sha256 = "sha256-jQ0J/faorh154zY/4JKwc6IibrliPrj8A52rvTeQy6g=";
  };

  cargoSha256 = "sha256-PNcrOh8I+8o9LC2S0S1l0Xey8Pp7VprwYaucj+G5PRw=";

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
