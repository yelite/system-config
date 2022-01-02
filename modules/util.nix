with builtins;
let importHybridModuleContainer = moduleContainerDef: (
  if typeOf moduleContainerDef == "path" then
    { nixosModules = [ (import moduleContainerDef) ]; }
  else if moduleContainerDef?hybridModulePaths then
    let modules = map (p: import p) moduleContainerDef.hybridModulePaths;
    in
    {
      nixosModules = catAttrs "nixosModule" modules;
      homeModules = catAttrs "homeModule" modules;
    }
  else if moduleContainerDef?homeManagerModulePaths then
    { homeModules = map (p: import p) moduleContainerDef.homeManagerModulePaths; }
  else throw "moduleContainerDef should be a path, or set with key `hybridModulePaths` or `homeManagerModulePaths`."
);
in
rec {
  splitHybridModules = modulesContainerDefs: (
    let
      hybridModuleContainers = map importHybridModuleContainer modulesContainerDefs;
      extractHomeModules = hybridModuleContainer:
        if hybridModuleContainer?homeModules then hybridModuleContainer.homeModules else [ ];
      extractNixOSModules = hybridModuleContainer:
        if hybridModuleContainer?nixosModules then hybridModuleContainer.nixosModules else [ ];
    in
    {
      homeModules = concatMap extractHomeModules hybridModuleContainers;
      systemModules = concatMap extractNixOSModules hybridModuleContainers;
    }
  );

  # Mark a module path as hybrid module
  # hybrid module has shape like { nixosModule = ...; homeModule = ...; }
  hybridModule = modulePath: hybridModules [ modulePath ];
  hybridModules = modulePaths: { hybridModulePaths = modulePaths; };

  # Mark a module path as home manager module
  homeManagerModule = modulePath: homeManagerModules [ modulePath ];
  homeManagerModules = modulePaths: { homeManagerModulePaths = modulePaths; };
}
