{ lib, ... }:
with lib; let
  modules' = dir: filterAttrs (name: type: (hasSuffix ".nix" name) || (type == "directory"))
    (builtins.readDir dir);
  modules = dir: mapAttrs' (name: _: nameValuePair (removeSuffix ".nix" name) (import (dir + "/${name}")))
    (modules' dir);
in
(modules ./modules)
