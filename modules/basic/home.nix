{ pkgs, inputs, ... }:
{
  imports = [
    ./rust.nix
  ];

  home.packages = with pkgs; [
    wget
    git
    unzip

    nix-index
    nix-tree
    nixpkgs-fmt
    cachix

    lazygit
    steam-run
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs = {
    keychain = {
      # TODO: Investigate the compatibility with sddm and re-enable this
      enable = false;
      enableBashIntegration = true;
      enableFishIntegration = true;

      keys = [ "id_ed25519" ];
    };
  };
}
