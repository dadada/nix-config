{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.dadada.weechat;
in {
  options.dadada.weechat = {
    enable = mkEnableOption "Enable weechat relay";
  };
  config = mkIf cfg.enable {
    services.weechat = {
      enable = true;
      sessionName = "weechat-dadada";
    };

    services.nginx.enable = true;

    services.nginx.virtualHosts."webchat.dadada.li" = {
      enableACME = true;
      forceSSL = true;

      root = pkgs.glowing-bear;

      locations = {
        "/robots.txt" = {
          extraConfig = ''
            add_header Content-Type text/plain;
            return 200 "User-agent: *\nDisallow: /\n";
          '';
        };
      };
    };
    services.nginx.virtualHosts."weechat.dadada.li" = {
      useACMEHost = "webchat.dadada.li";
      forceSSL = true;

      root = "${pkgs.nginx}/html";
      locations = {
        "/weechat" = {
          extraConfig = ''
            proxy_pass http://localhost:9001;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_read_timeout 8h;
          '';
        };
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
