let
  inherit (builtins) listToAttrs attrNames;
  attrToList = set:
    map (name: {
      name = name;
      value = set.${name};
    }) (attrNames set);
in (pkgs: rawPlugins:
    listToAttrs (
      map
      (
        item: let
          inherit (item) name;
        in {
          inherit name;
          value = pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = name;
            version = "flake";
            src = item.value;
          };
        }
      )
      (attrToList rawPlugins)
    ))
