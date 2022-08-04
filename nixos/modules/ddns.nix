{ config
, pkgs
, lib
, ...
}:
with lib; let
  cfg = config.dadada.ddns;
  ddnsConfig = hostNames: {
    systemd.timers = listToAttrs (forEach hostNames (hostname:
      nameValuePair "ddns-${hostname}"
        {
          wantedBy = [ "timers.target" ];
          partOf = [ "ddns-${hostname}.service" ];
          timerConfig.OnCalendar = "hourly";
        }));

    systemd.services = listToAttrs (forEach hostNames (hostname:
      nameValuePair "ddns-${hostname}"
        {
          serviceConfig.Type = "oneshot";
          script = ''
            function url() {
              echo "https://svc.joker.com/nic/update?username=$1&password=$2&hostname=$3"
            }

            IFS=':'
            read -r user password < /var/lib/ddns/credentials
            unset IFS

            curl_url=$(url "$user" "$password" ${hostname})

            ${pkgs.curl}/bin/curl -4 "$curl_url"
            ${pkgs.curl}/bin/curl -6 "$curl_url"
          '';
        }));
  };
in
{
  options = {
    dadada.ddns.domains = mkOption {
      type = types.listOf types.str;
      description = ''
        Enables DDNS for these domains.
      '';
      example = ''
        [ "example.com" ]
      '';
      default = [ ];
    };
  };

  config = ddnsConfig cfg.domains;
}
