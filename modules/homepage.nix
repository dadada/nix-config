{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.dadada.homePage;
  homePage = builtins.fetchTarball {
    url = "https://github.com/dadada/dadada.li/archive/c77ffc04882f32c2feced7d0f2d8ce3622060230.tar.gz";
      sha256 = "18jmwz8d6ap2wv9y6p0pb4w1n8vhm8fmjnpg5ngwl9dmhxq2svfv";
  };
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
