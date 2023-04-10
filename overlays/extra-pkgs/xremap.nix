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
    rev = "a73ad9cc06e394e595900fe9474893c213ffa3e7";
    sha256 = "sha256-/+8crvvDSvaNBHjcjlo468fkRol/9326W7cXn4wEcn4=";
  };

  cargoSha256 = "sha256-C7257iTTODYVQWvSG651DvpgfWGjNHyK45IQupvE8gc=";

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
