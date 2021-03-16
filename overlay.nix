self: super:
let
  isReserved = n: builtins.elem n [
    "lib"
    "hosts"
    "hmModules"
    "modules"
    "overlays"
    "profiles"
    "pythonPackages"
  ];
  nameValuePair = n: v: { name = n; value = v; };
  attrs = import ./default.nix { pkgs = super; };
in
builtins.listToAttrs
  (map (n: nameValuePair n attrs.${n})
    (builtins.filter (n: !isReserved n)
      (builtins.attrNames attrs)))
