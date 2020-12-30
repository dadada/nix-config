{ config, pkgs, lib, ... }:
with lib;
let
  dadadaKeys = ../../../pkgs/keys/keys;
in
{
  imports = import ../../module-list.nix;

  networking.domain = mkDefault "dadada.li";

  dadada.admin.users = {
    "dadada" = [ "${dadadaKeys}/dadada.pub" ];
  };

  #dadada.autoUpgrade = mkDefault true;

  environment.noXlibs = mkDefault true;
  documentation.enable = mkDefault false;
  documentation.nixos.enable = mkDefault false;

  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  console = mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

}
