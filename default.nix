{ nixpkgs, declInput, projectName, ... }:
let
  pkgs = import nixpkgs { };
in
{
  jobsets = import ./jobsets.nix { inherit pkgs declInput projectName; };
}
