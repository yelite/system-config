{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "goimports-reviser";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "incu6us";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JIXBC7fk/Bd3tTHiK+qtB+5CdAATaB/j1nvKOJrz4n4=";
  };

  vendorHash = "sha256-lyV4HlpzzxYC6OZPGVdNVL2mvTFE9yHO37zZdB/ePBg=";
  excludedPackages = [
    "linter"
  ];

  preCheck = let
    skippedTests = [
      "TestSourceFile_Fix_WithAliasForVersionSuffix"
    ];
  in ''
    buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
  '';

  meta = with lib; {
    description = "Right imports sorting & code formatting tool (goimports alternative)";
    homepage = "https://github.com/incu6us/goimports-reviser";
    license = licenses.mit;
    maintainers = with maintainers; [meain];
  };
}
