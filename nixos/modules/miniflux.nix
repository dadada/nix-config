{ config, lib, ... }:
let
  cfg = config.dadada.miniflux;
  domain = "miniflux.${config.networking.domain}";
  adminCredentialsFile = "miniflux-admin-credentials";
in
{

  options.dadada.miniflux = {
    enable = lib.mkEnableOption "Enable miniflux RSS aggregator";
  };

  config = lib.mkIf cfg.enable {
    services.miniflux = {
      enable = true;
      config = {
        CLEANUP_FREQUENCY = "48";
        LISTEN_ADDR = "localhost:8080";
      };
      adminCredentialsFile = config.age.secrets.${adminCredentialsFile}.path;
    };

    services.nginx.virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;

      locations."/".extraConfig = ''
        proxy_pass http://localhost:8080/;
      '';
    };

    age.secrets.${adminCredentialsFile} = {
      file = "${config.dadada.secrets.path}/${adminCredentialsFile}.age";
      mode = "0600";
    };
  };
}
