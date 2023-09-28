{
  lib,
  hostPlatform,
  buildGoModule,
  fetchFromGitHub,
  darwin,
  makeWrapper,
  pkg-config,
  libX11,
  libXrandr,
  libXinerama,
  libXcursor,
  libXi,
  libXext,
  libGL,
  mesa,
  mpv,
}:
buildGoModule rec {
  pname = "supersonic";
  version = "0.5.2";
  src = fetchFromGitHub {
    owner = "dweymouth";
    repo = pname;
    rev = "3321540bd38948a769eaab1e233e39dececbb3e9";
    sha256 = "sha256-4SLAUqLMoUxTSi4I/QeHqudO62Gmhpm1XbCGf+3rPlc=";
  };

  nativeBuildInputs = [pkg-config makeWrapper];

  buildInputs =
    [
      mpv
    ]
    ++ lib.optionals hostPlatform.isLinux [
      libX11
      libXrandr
      libXinerama
      libXcursor
      libXi
      libXext
      libGL
      mesa.dev
    ]
    ++ lib.optionals hostPlatform.isDarwin [
      # darwin.CarbonHeaders
      darwin.apple_sdk.frameworks.Cocoa
      darwin.apple_sdk.frameworks.Kernel
      darwin.apple_sdk.frameworks.UserNotifications
    ];

  postInstall = ''
    wrapProgram "$out/bin/supersonic" --set FYNE_SCALE 2
  '';

  vendorSha256 = "sha256-6Yp5OoybFpoBuIKodbwnyX3crLCl8hJ2r4plzo0plsY=";

  meta = {
    homepage = "https://github.com/dweymouth/supersonic";
    description = "A lightweight cross-platform desktop client for Subsonic music servers";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
