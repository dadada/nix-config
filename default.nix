{ pkgs ? import <nixpkgs> }:

with pkgs;
{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  hmModules = import ./modules/home;
  overlays = import ./overlays;

  profiles = import ./modules/profiles;
  hmProfiles = import ./modules/home/profiles;

  tubslatex = callPackage ./pkgs/tubslatex {};
  keys = callPackage ./pkgs/keys {};
}
