{ pkgs, lib, hostPlatform, ... }:
{
  home.packages = with pkgs; [
    jq
    fx
    htop

    ninja
    clang-tools 

    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer

    cloc

    deadnix

    python3
  ] ++ (with python3Packages; [
    ipython
    black
  ]) ++ lib.optionals hostPlatform.isLinux [
    insomnia
  ] ++ lib.optionals hostPlatform.isDarwin [
    (pkgs.writeShellScriptBin "gsed" "exec -a $0 ${gnused}/bin/sed $@")
  ];

  programs.go = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Lite Ye";
    userEmail = "yelite958@gmail.com";
  };
}
