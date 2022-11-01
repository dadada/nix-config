{ config, pkgs, lib, ... }:
let
  cfg = config.dadada.home.helix;
in
{
  options.dadada.home.helix.enable = lib.mkEnableOption "Enable helix editor";

  config = lib.mkIf cfg.enable {
    home.file.".config/helix".source = ./config;
    home.packages = [ pkgs.helix ];
  };
}
