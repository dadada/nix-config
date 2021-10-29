{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.dadada.home.gtk;
in
{
  options.dadada.home.gtk = {
    enable = mkEnableOption "Enable GTK config";
  };
  config = mkIf cfg.enable {
    gtk = {
      enable = true;
    };
  };
}
