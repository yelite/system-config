{
  description = "Config for my home computers";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, utils, nixpkgs, ... }@inputs: utils.lib.mkFlake
    {
      inherit self inputs;

      channelsConfig.allowUnfree = true;

      hosts = {
        moonshot.modules = [
          ./hosts/moonshot
          ./modules/desktop.nix
          ./modules/keyboard-remap
          {
            home-manager.users.liteye.imports = [
              ./home/gui.nix
              ./modules/keyboard-remap/user.nix
            ];
          }
        ];
      };

      hostDefaults.modules = [
        ./modules/basic.nix
        ./modules/cachix.nix
        inputs.hm.nixosModule
        {
          home-manager = {
            useGlobalPkgs = true;
          };
        }
      ];
    };
}
