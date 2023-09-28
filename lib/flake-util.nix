{lib}: let
  inherit (builtins) mapAttrs;
  myModules = import ../modules;
in {
  # This wraps mkFlake from flake-utils-plus to:
  # - Add hostPlatform to module inputs as specialArgs
  # - Add all custom modules to the host definition depending on system type
  wrapMkFlake = {
    mkFlake,
    homeManager,
  }: args: (
    let
      defaultSystem = args.hostDefaults.system or "x86_64-linux";
      getHomeManagerModule = hostPlatform:
        if hostPlatform.isLinux
        then homeManager.nixosModule
        else if hostPlatform.isDarwin
        then homeManager.darwinModule
        else throw "Not supported system type ${hostPlatform._name}";
      mkHost = name: host: let
        hostPlatform = lib.systems.elaborate (host.system or defaultSystem);
        modules =
          myModules
          ++ [
            ../hosts/${name}
            (getHomeManagerModule hostPlatform)
          ]
          ++ (host.modules or []);
      in
        (lib.deepMergeAttrs host {
          specialArgs.hostPlatform = hostPlatform;
        })
        // {
          inherit modules;
        };
      patchedArgs =
        args
        // {
          hosts = mapAttrs mkHost (args.hosts or {});
        };
    in
      mkFlake patchedArgs
  );
}
