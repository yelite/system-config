{ lib
, buildGoModule
, fetchFromGitHub
, darwin
, mpv
}:

buildGoModule rec {
  pname = "supersonic";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "dweymouth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-shUeq4fDJ/WUnMiyVkmfO9EjwiNEeqaVMdmSIBeNbY8=";
  };

  # nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    mpv
    # darwin.CarbonHeaders
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.Kernel
    darwin.apple_sdk.frameworks.UserNotifications
  ];
  vendorSha256 = "sha256-vj9jnuaSoqRytpX4dNuKIsr2Qc5xC6SL8XjMxPQx/m8=";

  meta = {
    homepage = "https://github.com/dweymouth/supersonic";
    description = "A lightweight cross-platform desktop client for Subsonic music servers";
    license = lib.licenses.gpl3;
    # maintainers = with lib.maintainers; [ Profpatsch ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
