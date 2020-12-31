{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.dadada.share;
in {
  options.dadada.share = {
    enable = mkEnableOption "Enable file share";
  };
  config = mkIf cfg.enable {
    services.nginx.enable = true;

    services.nginx.virtualHosts."share.dadada.li" = {
      enableACME = true;
      forceSSL = true;

      root = "/var/lib/share";

      locations = {
        "/robots.txt" = {
          extraConfig = ''
            add_header Content-Type text/plain;
            return 200 "User-agent: *\nDisallow: /\n";
          '';
        };
      };
    };
  };
}

