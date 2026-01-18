{
  lib,
  hostPlatform,
  config,
  ...
}: let
  # Firefox on macOS reads policies from ~/Library/Preferences/<bundle-id>, NOT from
  # ~/Library/Application Support/Firefox/distribution/policies.json
  # https://github.com/mozilla/policy-templates/blob/master/mac/README.md
  #
  # Nested policy keys must be flattened with "__" separator.
  # e.g., FirefoxHome.Search -> FirefoxHome__Search
  flattenPolicies = prefix: attrs:
    lib.foldlAttrs (
      acc: name: value: let
        key =
          if prefix == ""
          then name
          else "${prefix}__${name}";
      in
        if builtins.isAttrs value && !(builtins.isList value)
        then acc // (flattenPolicies key value)
        else acc // {${key} = value;}
    ) {}
    attrs;

  policies = config.programs.firefox.policies;
  flatPolicies = flattenPolicies "" policies;
in
  lib.mkIf hostPlatform.isDarwin {
    home.file."${config.programs.firefox.configPath}/profiles.ini".text =
      lib.mkForce
      ''
        [Profile0]
        Name=dev-edition-default
        IsRelative=1
        Path=Profiles/main.dev-edition-default

        [General]
        StartWithLastProfile=1
      '';

    # Firefox Developer Edition on macOS reads policies from preferences domain
    # https://github.com/nix-community/home-manager/issues/6902
    targets.darwin.defaults."org.mozilla.firefoxdeveloperedition" =
      {
        EnterprisePoliciesEnabled = true;
      }
      // flatPolicies;
  }
