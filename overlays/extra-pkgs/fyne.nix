{
  lib,
  hostPlatform,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "fyne";
  version = "2.4.1";
  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-g/nAxX1LdLf9oithrZnAuAQESewyTpxNpqFn9b7L9vA=";
  };

  subPackages = ["cmd/fyne"];

  vendorHash = "sha256-KzG+hafufYlLMEpN8HCOGpxO1IQ3K+1HJjGwL10pNXI=";

  meta = {
    homepage = "https://github.com/fyne-io/fyne";
    description = "Cross platform GUI toolkit in Go inspired by Material Design";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
