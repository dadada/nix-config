{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.dadada.homePage;
  homePage = builtins.fetchTarball {
    url = "https://github.com/dadada/dadada.li/archive/c77ffc04882f32c2feced7d0f2d8ce3622060230.tar.gz";
      sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
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
