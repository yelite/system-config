let
  inherit (builtins) listToAttrs attrNames;
  attrToList = set:
    map (name: {
      name = name;
      value = set.${name};
    }) (attrNames set);
in (buildVimPlugin: rawPlugins:
    listToAttrs (
      map
      (
        item: let
          inherit (item) name;
        in {
          inherit name;
          value = buildVimPlugin {
            pname = name;
            version = "flake";
            src = item.value;
          };
        }
      )
      (attrToList rawPlugins)
    ))
