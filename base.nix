{localInputs}: {...}: let
  inputs = localInputs;
in {
  lite-system = {
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
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
