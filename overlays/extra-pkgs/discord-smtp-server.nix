{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "discord-smtp-server";
  version = "0-dev";

  src = fetchFromGitHub {
    owner = "kylegrantlucas";
    repo = pname;
    rev = "045d6a7901afc61daf6a06321b614628c50332fa";
    sha256 = "sha256-Ev8r4b7QkA3gh1rnWGyYjafxNixFJLF0ujnm40fZFLQ=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "A simple SMTP-Discord Webhook relay.";
    homepage = "https://github.com/kylegrantlucas/discord-smtp-server";
    license = licenses.mit;
  };
}
