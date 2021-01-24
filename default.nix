{ pkgs ? import <nixpkgs> { } }:

with pkgs;
rec {
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  hmModules = import ./modules/home;
  overlays = import ./overlays;

  profiles = import ./modules/profiles;
  hmProfiles = import ./modules/home/profiles;

  hosts = import ./hosts;

  tubslatex = callPackage ./pkgs/tubslatex { };
  keys = callPackage ./pkgs/keys { };
  homePage = callPackage ./pkgs/homePage { };
  deploy = callPackage ./pkgs/deploy.nix { };
  scripts = callPackage ./pkgs/scripts.nix { };
}
