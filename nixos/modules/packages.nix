{ config, lib, ... }:
{
  options = {
    dadada.pkgs = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      description = "Additional packages that are not sourced from nixpkgs";
      default = { };
    };
  };
}
