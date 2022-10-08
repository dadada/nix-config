{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.dadada.gitea;
in
{
  options.dadada.gitea = {
    enable = lib.mkEnableOption "Enable gitea";
  };
  config = lib.mkIf cfg.enable {
    services.gitea = {
      enable = true;
      appName = "dadada Gitea";
      rootUrl = "https://git.dadada.li/";
      log.level = "Error";
      domain = config.networking.domain;
      ssh.enable = true;
      cookieSecure = true;
      enableUnixSocket = true;
      database = {
        type = "postgres";
      };
      disableRegistration = true;
      settings = {
        server = {
          LANDING_PAGE = "explore";
          OFFLINE_MODE = true;
        };
        picture = {
          DISABLE_GRAVATAR = true;
          REPOSITORY_AVATAR_FALLBACK = "random";
          ENABLE_FEDERATED_AVATAR = false;
        };
        other = {
          SHOW_FOOTER_BRANDING = false;
          SHOW_FOOTER_VERSION = false;
          SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
        };
        log = {
          DISABLE_ROUTER_LOG = true;
        };
        cache = {
          ENABLE = true;
          ADAPTER = "redis";
          HOST = "network=unix,addr=${config.services.redis.servers.gitea.unixSocket},db=0,pool_size=100,idle_timeout=180";
        };
      };
    };

    services.redis = {
      servers.gitea = {
        enable = true;
        user = config.services.gitea.user;
      };
      vmOverCommit = true;
    };

    services.nginx.virtualHosts."git.${config.networking.domain}" = {
      enableACME = true;
      forceSSL = true;

      locations."/".extraConfig = ''
        proxy_pass http://unix:/run/gitea/gitea.sock:/;
      '';
    };
  };
}
