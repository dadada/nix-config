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
        address localhost

      [surgat]
        address 10.3.3.1

      [agares]
        address 192.168.101.1
    '';
  };
  services.munin-node.enable = true;
}
