{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.dadada.element;
in {
  options.dadada.element = {
    enable = lib.mkEnableOption "Enable element webapp";
  };
  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts."element.${config.networking.domain}" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "element.${config.networking.domain}"
      ];

      root = pkgs.element-web.override {
        conf = {
          default_server_config."m.homeserver" = {
            "base_url" = "https://matrix.stratum0.org/";
            "server_name" = "Stratum 0";
          };
        };
      };

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
