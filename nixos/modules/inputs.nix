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

  config = { };
}
