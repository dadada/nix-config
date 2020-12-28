{ config, pkgs, lib, ... }:
with lib;
{
  imports = import ../../module-list.nix;

  networking.domain = mkDefault "dadada.li";
  dadada.autoUpgrade = mkDefault true;

  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  console = mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

}
