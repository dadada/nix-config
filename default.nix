{ pkgs ? import <nixpkgs> { } }:

with pkgs;
let
  myPythonPackages = import ./pkgs/python-pkgs;
  myPython3Packages = myPythonPackages { callPackage = python3Packages.callPackage; };
in
rec {
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  hmModules = import ./modules/home;
  overlays = import ./overlays;

  profiles = import ./modules/profiles;

  hosts = import ./hosts;

  pythonPackages = myPythonPackages;

  keys = callPackage ./pkgs/keys { };
  homePage = callPackage ./pkgs/homePage { };
  deploy = callPackage ./pkgs/deploy.nix { };

  recipemd = python3Packages.toPythonApplication myPython3Packages.recipemd;

  scripts = callPackage ./pkgs/scripts.nix { };
}
