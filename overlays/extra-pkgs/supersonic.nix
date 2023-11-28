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
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "dweymouth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rNM3kQrEkqLAW6Dia+VsEi9etUG218AL8tO0amWXb34=";
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
      darwin.apple_sdk.frameworks.MediaPlayer
    ];

  vendorSha256 = "sha256-I4ZZmQfYTMtNT+3WCs6/g42uF4EKGSjGHCqG8Du5rCo=";

  meta = {
    homepage = "https://github.com/dweymouth/supersonic";
    description = "A lightweight cross-platform desktop client for Subsonic music servers";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
