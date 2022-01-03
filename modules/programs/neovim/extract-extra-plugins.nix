let
  inherit (builtins) listToAttrs attrNames filter stringLength substring;
  attrToList = set: map (name: { name = name; value = set.${name}; }) (attrNames set);
  prefix = "neovim";
  prefixLength = stringLength prefix;
  isPluginInput = item: (substring 0 prefixLength item.name) == prefix;
  getPluginName = inputName: substring (prefixLength + 1) (stringLength inputName) inputName;
in
# Here it extract all inputs with prefix in their names, and build them as vim plugins
(pkgs: inputs:
  let
    pluginInputs = filter isPluginInput (attrToList inputs);
  in
  listToAttrs (map
    (item:
      let name = getPluginName item.name; in
      {
        inherit name;
        value = pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = name;
          version = "flake";
          src = item.value;
        };
      }
    )
    pluginInputs
  ))
