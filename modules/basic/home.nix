{ pkgs, inputs, ... }:
{
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
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableXsessionIntegration = true;

      keys = [ "id_ed25519" ];
    };
  };
}
