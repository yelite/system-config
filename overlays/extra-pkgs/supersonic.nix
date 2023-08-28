{ lib
, hostPlatform
, buildGoModule
, fetchFromGitHub
, darwin
, makeWrapper
, pkg-config
, libX11
, libXrandr
, libXinerama
, libXcursor
, libXi
, libXext
, libGL
, mesa
, mpv
}:

buildGoModule rec {
  pname = "supersonic";
  version = "0.5.2-dev";
  src = fetchFromGitHub {
    owner = "yelite";
    repo = pname;
    rev = "7873cccff6c1952dfaa1d7279903d7a3077cd5ad";
    sha256 = "sha256-AEcPrvVbtDG63s9M/+bwbAC/2SWeUnPqdi3gE4AaTlc=";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [
    mpv
  ] ++ lib.optionals hostPlatform.isLinux [
    libX11
    libXrandr
    libXinerama
    libXcursor
    libXi
    libXext
    libGL
    mesa.dev
  ] ++ lib.optionals hostPlatform.isDarwin [
    # darwin.CarbonHeaders
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.Kernel
    darwin.apple_sdk.frameworks.UserNotifications
  ];

  postInstall = ''
    wrapProgram "$out/bin/supersonic" --set FYNE_SCALE 2
  '';

  vendorSha256 = "sha256-Pm3xuEWECBsga8oT+IYJpL4gAI7WcTizCd8twKBQ284=";

  meta = {
    homepage = "https://github.com/dweymouth/supersonic";
    description = "A lightweight cross-platform desktop client for Subsonic music servers";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
