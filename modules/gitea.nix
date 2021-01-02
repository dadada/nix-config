{ config, pkgs, lib, ... }:
let
  cfg = config.dadada.gitea;
in {
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
