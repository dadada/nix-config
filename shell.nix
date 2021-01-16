{ pkgs ? import <nixpkgs> { } }:

with (import ./default.nix { inherit pkgs; });
pkgs.mkShell {
  buildInputs = [
    deploy
  ];
}
