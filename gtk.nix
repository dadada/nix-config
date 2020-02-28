{ config, pkgs, ... }:
{
  gtk = {
    theme.package = pkgs.gnome-themes-extra;
    theme.name = "Adwaita Dark:";
    iconTheme.package = pkgs.adwaita-icon-theme;
    iconTheme.name = "Adwaita";
    font.package = pkgs.cantarell-fonts;
  };
}
