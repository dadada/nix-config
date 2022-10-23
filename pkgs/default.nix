{ pkgs
, ...
} @ inputs:
{
  map = pkgs.callPackage ./map.nix { };
}
