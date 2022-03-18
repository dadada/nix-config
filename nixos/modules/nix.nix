{ self
, home-manager
, nixpkgs
, ...
}:
{ config, pkgs, lib, ... }:
# Global settings for nix daemon
{
  nix.nixPath = [
    "home-manager=${home-manager}"
    "nixpkgs=${nixpkgs}"
    "dadada=${self}"
  ];
  nix.registry = {
    home-manager.flake = home-manager;
    nixpkgs.flake = nixpkgs;
    dadada.flake = self;
  };
  nix.settings.substituters = [
    https://cache.nixos.org/
    https://nix-community.cachix.org/
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "gorgon:eEE/PToceRh34UnnoFENERhk89dGw5yXOpJ2CUbfL/Q="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  nix.settings.require-sigs = true;
  nix.settings.sandbox = true;
}
