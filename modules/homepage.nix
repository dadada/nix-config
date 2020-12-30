{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.dadada.homePage;
  homePage = import (builtins.fetchTarball {
    url = "https://github.com/dadada/dadada.li/archive/cb85ed00594f1d4396fe3f61f92e0ff19595596d.tar.gz";
    sha256 = "176l913xsg9gicglkmpmnqwjn8r0psyyj2vx5pi26v0angnfg80a";
  }) {};
in {
  options.dadada.homePage = {
    enable = mkEnableOption "Enable home page";
  };
  config = mkIf cfg.enable {
    services.nginx.enable = true;

    services.nginx.virtualHosts."dadada.li" = {
      enableACME = true;
      forceSSL = true;
      root = homePage;
    };
  };
}
