{ config, pkgs, ... }:
{
  gtk = {
    enable = true;
    theme.package = pkgs.gnome3.gnome-themes-extra;
    theme.name = "Adwaita-dark";
    iconTheme.package = pkgs.gnome3.adwaita-icon-theme;
    iconTheme.name = "Adwaita";
    font.package = pkgs.cantarell-fonts;
    font.name = "Cantarell";
  };
  dconf.settings."org/gnome/desktop/interface" = {
    enable-animations = false;
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}
