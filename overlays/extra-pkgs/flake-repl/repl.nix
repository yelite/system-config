{
  flakePath ? null,
  hostname ? null,
  hostnamePath ? "/etc/hostname",
  registryPath ? /etc/nix/registry.json,
}: let
  inherit (builtins) getFlake head match currentSystem readFile pathExists filter fromJSON;

  selfFlake = let
    registryContent = builtins.unsafeDiscardStringContext (readFile registryPath);
  in
    if pathExists registryPath
    then filter (it: it.from.id == "self") (fromJSON registryContent).flakes
    else [];

  flakePath' =
    toString
    (
      if flakePath != null
      then flakePath
      else if selfFlake != []
      then (head selfFlake).to.path
      else "/etc/nixos"
    );

  flake =
    if pathExists flakePath'
    then getFlake flakePath'
    else {};
  hostname' = (
    if hostname != null
    then hostname
    else if pathExists hostnamePath
    then head (match "([a-zA-Z0-9\\-]+)\n" (readFile hostnamePath))
    else ""
  );

  nixpkgsFromInputsPath = flake.inputs.nixpkgs.outPath or "";
  nixpkgs =
    if nixpkgsFromInputsPath != ""
    then import nixpkgsFromInputsPath {}
    else {};
  lib = nixpkgs.lib;

  nixpkgsOutput = removeAttrs (nixpkgs // nixpkgs.lib or {}) ["options" "config"];
in
  {inherit flake;}
  // flake
  // builtins
  // {
    pkgs = nixpkgsOutput;
    getFlake = path: getFlake (toString path);
  }
  // lib.optionalAttrs (flakePath == null) (
    let
      systemConfig =
        if (match ".*-darwin$" currentSystem) == null
        then
          (
            flake.nixosConfigurations.${hostname'} or {}
          )
        else
          (
            flake.darwinConfigurations.${hostname'} or {}
          );
    in {
      inherit systemConfig;
      pkgs = systemConfig.config.nixpkgs.pkgs or nixpkgsOutput;
    }
  )
