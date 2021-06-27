{ config, pkgs, lib, ... }:
with lib;
{

  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "gorgon:eEE/PToceRh34UnnoFENERhk89dGw5yXOpJ2CUbfL/Q="
  ];

  nixpkgs.overlays = attrValues (import ../../../overlays);

  imports = import ../../module-list.nix;

  networking.domain = mkDefault "dadada.li";

  dadada.admin.users = {
    "dadada" = [ "${pkgs.dadadaKeys}/dadada.pub" ];
  };

  dadada.autoUpgrade.enable = mkDefault true;

  environment.noXlibs = mkDefault true;
  documentation.enable = mkDefault false;
  documentation.nixos.enable = mkDefault false;

  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  console = mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

}
