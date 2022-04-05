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
    rev = "015b06a4c9ee6a9ac1b885aa66b0655e5dc43739";
    sha256 = "sha256-DPcoC1mNWVCJKFgP0vTd4yosUEE5UZzUDSS1z0+4gTI=";
  };

  cargoSha256 = "sha256-bVZy0noM42AZVAAejiyC1HCasGBd40PK+K11w6K7oiM=";

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
