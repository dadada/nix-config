{ pkgs ? import <nixpkgs> { } }:

with pkgs;
rec {
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  hmModules = import ./modules/home;
  overlays = import ./overlays;

  profiles = import ./modules/profiles;

  hosts = import ./hosts;

  pythonPackages = ./pkgs/python-pkgs;

  tubslatex = callPackage ./pkgs/tubslatex { };
  keys = callPackage ./pkgs/keys { };
  homePage = callPackage ./pkgs/homePage { };
  deploy = callPackage ./pkgs/deploy.nix { };
  recipemd = python3.pkgs.toPythonApplication (python3Packages.callPackage ./pkgs/python-pkgs/recipemd { });
  scripts = callPackage ./pkgs/scripts.nix { };
}
