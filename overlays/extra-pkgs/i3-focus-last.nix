{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "i3-focus-last";
  version = "ef8affae96179568be5faa04fd1542ceb7285964";

  src = fetchFromGitHub {
    owner = "lbonn";
    repo = pname;
    rev = "e551306c422552915f7e5ec0b7d5185d6bcd3dd1";
    sha256 = "sha256-KL3NxnzppOzlg4QW96Qh3WLHIwX0ctRdVmZR2yZhEnM=";
  };

  cargoSha256 = "sha256-spxgNZP4bgbvP7vX9IfSS3Zg0E/luZHpCvvTwbD4zgk=";

  meta = {
    description = "Another implementation of this classic (and useful) example of i3 ipc use.";
    homepage = "https://github.com/lbonn/i3-focus-last";
  };
}
