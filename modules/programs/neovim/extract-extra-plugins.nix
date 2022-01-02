let
  listToAttrs = builtins.listToAttrs;
  attrToList = (set: map (name: { name = name; value = set.${name}; }) (builtins.attrNames set));
  filter = builtins.filter;
  stringLength = builtins.stringLength;
  substring = builtins.substring;

  prefix = "neovim";
  prefixLength = stringLength prefix;

  # Here it extract all inputs with prefix in their names, and build them as vim plugins
  extractPluginPackages = (pkgs: inputs: listToAttrs (map
    (item:
      let name = substring (prefixLength + 1) (stringLength item.name) item.name; in
      {
        name = name;
        value = pkgs.vimUtils.buildVimPluginFrom2Nix { pname = name; version = "flake"; src = item.value; };
      })
    (filter (item: (substring 0 prefixLength item.name) == prefix)
      (attrToList inputs))));
in
extractPluginPackages
