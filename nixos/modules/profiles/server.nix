{ config, pkgs, lib, ... }:
with lib;
let
  keys = [ ../../../keys/dadada.pub ];
in {
  networking.domain = mkDefault "dadada.li";

  dadada.admin.users = {
    "dadada" = keys;
  };

  dadada.networking.useLocalResolver = true;

  dadada.autoUpgrade.enable = mkDefault true;

  environment.noXlibs = mkDefault true;
  documentation.enable = mkDefault false;
  documentation.nixos.enable = mkDefault false;

  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  console = mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.journald.extraConfig = ''
    SystemKeepFree = 2G
  '';
}
