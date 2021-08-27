{ homePage }:
{ config, pkgs, lib, ... }:
let
  cfg = config.dadada.homePage;
  homePagePkg = pkgs.callPackage homePage { };
in
with lib; {
  options.dadada.homePage = {
    enable = mkEnableOption "Enable home page";
  };
  config = mkIf cfg.enable {
    services.nginx.enable = true;

    services.nginx.virtualHosts."dadada.li" = {
      enableACME = true;
      forceSSL = true;
      root = "${homePagePkg}";
    };
  };
}
