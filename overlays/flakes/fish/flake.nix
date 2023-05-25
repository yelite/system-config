{
  description = "Extra plugins for fish";

  outputs = inputs:
    let
      inherit (builtins) map attrNames;
      pluginSources = inputs;
      pluginNames = attrNames pluginSources;
    in
    {
      overlay = (final: prev: {
        myFishPlugins = map (name: { inherit name; src = pluginSources.${name}; }) pluginNames;
      });
    };

  inputs = {
    z = {
      url = "github:jethrokuan/z";
      flake = false;
    };
    fzf-fish = {
      url = "github:PatrickF1/fzf.fish";
      flake = false;
    };
    forgit = {
      url = "github:wfxr/forgit";
      flake = false;
    };
    done = {
      url = "github:franciscolourenco/done";
      flake = false;
    };
    replay = {
      url = "github:jorgebucaran/replay.fish";
      flake = false;
    };
    sponge = {
      url = "github:andreiborisov/sponge";
      flake = false;
    };
    autopair = {
      url = "github:jorgebucaran/autopair.fish";
      flake = false;
    };
  };
}
