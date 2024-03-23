{ config, ... }:
{
  services.nginx.enable = true;
  services.nginx.virtualHosts."ninurta.bs.dadada.li" = {
    addSSL = false;
    enableACME = false;
    root = "/var/www/munin/";
    locations = {
      "/" = {
        root = "/var/www/munin/";
      };
    };
  };
  services.munin-cron = {
    enable = true;
    hosts = ''
      [${config.networking.hostName}]
        address 10.3.3.3

      [surgat]
        address 10.3.3.1

      [agares]
        address 10.3.3.2
    '';
  };
  services.munin-node.enable = true;
}
