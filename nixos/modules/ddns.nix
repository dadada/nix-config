{ config
, pkgs
, lib
, ...
}:
with lib; let
  cfg = config.dadada.ddns;
  ddnsConfig = { domains, credentialsPath, interface }: {
    systemd.timers = listToAttrs (forEach domains (domain:
      nameValuePair "ddns-${domain}"
        {
          wantedBy = [ "timers.target" ];
          partOf = [ "ddns-${domain}.service" ];
          timerConfig.OnCalendar = "hourly";
        }));

    systemd.services = listToAttrs (forEach domains (domain:
      nameValuePair "ddns-${domain}"
        {
          serviceConfig.Type = "oneshot";
          script = ''
            function url() {
              echo "https://svc.joker.com/nic/update?username=$1&password=$2&hostname=$3"
            }

            IFS=':'
            read -r user password < ${credentialsPath}
            unset IFS

            curl_url=$(url "$user" "$password" ${domain})

            ${pkgs.curl}/bin/curl -6 "$curl_url" ${if interface == null then "" else "--interface ${interface}"}
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
    dadada.ddns.credentialsPath = mkOption {
      type = types.path;
      description = "Credentials file";
      default = "/var/lib/ddns/credentials";
    };
    dadada.ddns.interface = mkOption {
      type = types.nullOr types.str;
      description = "Source interface to use";
      default = null;
    };
  };

  config = with cfg; ddnsConfig { inherit domains interface credentialsPath; };
}
