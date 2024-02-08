{
  inputs,
  self,
  ...
}: let
  inherit (inputs) deploy-rs;
in {
  flake.deploy = {
    nodes = {
      crater = {
        hostname = "crater.home";

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.crater;
        };

        sudo = "doas -u";
        sshOpts = ["-t"];
        sshUser = "liteye";
        magicRollback = false;
      };
    };
  };

  flake.check = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

  perSystem = {inputs', ...}: {
    apps.deploy = inputs'.deploy-rs.apps.deploy-rs;
  };
}
