{ config, ... }:
{
  dadada.ddns = {
    domains = [ "vpn.dadada.li" ];
    credentialsPath = config.age.secrets."ddns-credentials".path;
    interface = "wan";
  };

  age.secrets."ddns-credentials" = {
    file = "${config.dadada.secrets.path}/ddns-credentials.age";
    mode = "400";
  };
}
