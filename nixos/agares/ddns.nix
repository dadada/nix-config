{ config, ... }:
{
  dadada.ddns = {
    domains = [ "vpn.dadada.li" ];
    credentialsPath = config.age.secrets."ddns-credentials".path;
    interface = "ppp0";
  };

  age.secrets."ddns-credentials" = {
    file = "${config.dadada.secrets.path}/ddns-credentials.age";
    mode = "400";
  };
}
