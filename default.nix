{ pkgs ? import <nixpkgs> }:

with pkgs;
{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  hmModules = import ./modules/home;
  overlays = import ./overlays;

  tubslatex = callPackage ./pkgs/tubslatex {};
  keys = callPackage ./pkgs/keys {};
}
