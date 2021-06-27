{ config, pkgs, lib, ... }:
with lib;
{
  networking.domain = mkDefault "dadada.li";

  dadada.admin.users = {
    "dadada" = [ "${pkgs.keys}/dadada.pub" ];
  };

  dadada.autoUpgrade.enable = mkDefault false;

  environment.noXlibs = mkDefault true;
  documentation.enable = mkDefault false;
  documentation.nixos.enable = mkDefault false;

  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  console = mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}
