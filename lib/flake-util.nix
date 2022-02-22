let
  inherit (builtins) mapAttrs remoteAttrs;
  inherit (import ./attrset.nix) deepMergeAttrs;
  inherit (import ../modules) getSystemModules;
  isMatch = pattern: s: builtins.isList (builtins.match pattern s);
  getSystemInfo = system: {
    _name = system;
    isDarwin = isMatch ".*-darwin$" system;
    isLinux = isMatch ".*-linux$" system;
    isX86 = isMatch "^x86.*" system;
    isArm = isMatch "^aarch64.*" system;
  };
in
{
  # This wraps mkFlake from flake-utils-plus to:
  # - Add systemInfo.isDarwin/Linux/X86/Arm to module inputs as specialArgs
  # - Add all custom modules to the host definition depending on system type
  wrapMkFlake = { mkFlake, homeManager }: args: (
    let
      defaultSystem = args.hostDefaults.system or "x86_64-linux";
      getHomeManagerModule = systemInfo:
        if systemInfo.isLinux then
          homeManager.nixosModule
        else if systemInfo.isDarwin then
          homeManager.darwinModule
        else
          throw "Not supported system type ${systemInfo._name}";
      getModulesForHost = name: systemInfo: extraModules:
        (getSystemModules systemInfo) ++
        [
          ../hosts/${name}
          (getHomeManagerModule systemInfo)
        ] ++
        extraModules;
      mkHost = name: host:
        let
          systemInfo = getSystemInfo (host.system or defaultSystem);
          modules = getModulesForHost name systemInfo (host.modules or [ ]);
        in
        (deepMergeAttrs host {
          specialArgs.systemInfo = systemInfo;
        }) // {
          inherit modules;
        };
      patchedArgs = args // {
        hosts = mapAttrs mkHost (args.hosts or { });
      };
    in
    mkFlake patchedArgs
  );
}
