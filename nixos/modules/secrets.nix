{ config, lib, ... }:
{
  options = {
    dadada.secrets.path = lib.mkOption {
      type = lib.types.path;
      description = "Path to encrypted secrets files";
      default = ../../secrets;
    };
  };
}
