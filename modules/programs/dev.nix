{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly

    python39
  ] ++ (with python39Packages; [
    ipython
  ]);

  programs.git = {
    enable = true;
    userName = "Lite Ye";
    userEmail = "yelite958@gmail.com";
  };
}
