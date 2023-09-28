{lib}: let
  inherit (builtins) isAttrs zipAttrsWith length head elemAt;
in {
  deepMergeAttrs = lhs: rhs: let
    f = zipAttrsWith (
      name: values:
        if
          length values
          > 1
          && isAttrs (head values)
          && isAttrs (elemAt values 1)
        then f values
        else head values
    );
  in
    f [rhs lhs];
}
