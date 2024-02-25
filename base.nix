{localInputs}: {...}: let
  inputs = localInputs;
in {
  imports = [
    inputs.lite-system.flakeModule
    ./flake-modules/formatter.nix
  ];

  config.lite-system = {
    nixpkgs = {
      config = {
        allowUnfree = true;
      };
      overlays = [
        inputs.fenix.overlays.default
        (inputs.get-flake ./overlays/flakes/neovim).overlay
        (inputs.get-flake ./overlays/flakes/fish).overlay
        (import ./overlays/extra-pkgs)
      ];
    };

    systemModule = ./system;
    homeModule = ./home;

    homeConfigurations = {
      liteye = {
        myHomeConfig = {
          neovim.enable = true;
          fish.enable = true;
        };
      };
    };
  };
}
