{ pkgs, lib, hostPlatform, ... }:
{
  home.packages = with pkgs; [
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
