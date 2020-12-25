self: super:

let
  isReserved = n: n == "lib" || n == "overlays" || n == "modules";
  nameValuePair = n: v: { name = n; value = v; };
  attrs = import ./default.nix { pkgs = super; };
in
  builtins.listToAttrs
  (map (n: nameValuePair n attrs.${n})
  (builtins.filter (n: !isReserved n)
  (builtins.attrNames attrs)))
