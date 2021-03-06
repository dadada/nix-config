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
      theme.package = pkgs.gnome3.gnome-themes-extra;
      theme.name = "Adwaita-dark";
      iconTheme.package = pkgs.gnome3.adwaita-icon-theme;
      iconTheme.name = "Adwaita";
      font.package = pkgs.cantarell-fonts;
      font.name = "Cantarell";
    };
  };
}
