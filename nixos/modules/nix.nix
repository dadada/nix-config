{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.dadada.inputs;
in
{
  options = {
    dadada.inputs = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      description = "Flake inputs that should be available inside Nix modules";
      default = { };
    };
  };

  config = {
    nix.nixPath = lib.mapAttrsToList (name: value: "${name}=${value}") cfg;
    nix.registry = lib.mapAttrs' (name: value: lib.nameValuePair name { flake = value; }) cfg;

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
  };
}
