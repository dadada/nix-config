{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.dadada.homePage;
  homePage = import (builtins.fetchTarball {
    url = "https://github.com/dadada/dadada.li/archive/c77ffc04882f32c2feced7d0f2d8ce3622060230.tar.gz";
      sha256 = "1b48m13yjmw7bpm1jikydv8janys07l6l37yhs1znnj4ygl4hz1d";
  });
in {
  options.dadada.homePage = {
    enable = mkEnableOption "Enable home page";
  };
  config = mkIf cfg.enable {
    services.nginx.enable = true;

    services.nginx.virtualHosts."dadada.li" = {
      enableACME = true;
      forceSSL = true;
      root = pkgs.callPackage homePage {};
    };
  };
}
