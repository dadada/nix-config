# Source https://github.com/NixOS/nixpkgs/issues/113384
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dadada.kanboard;
in {
  options = {
    dadada.kanboard.enable = lib.mkEnableOption "Enable Kanboard";
  };

  config = lib.mkIf cfg.enable {
    services.phpfpm.pools.kanboard = {
      user = "kanboard";
      group = "kanboard";
      settings = {
        "listen.group" = "nginx";
        "pm" = "static";
        "pm.max_children" = 4;
      };
    };
    users.users.kanboard.isSystemUser = true;
    users.users.kanboard.group = "kanboard";
    users.groups.kanboard.members = ["kanboard"];

    systemd.tmpfiles.rules = [
      "d /var/lib/kanboard/data 0750 kanboard nginx - -"
    ];

    services.nginx = {
      enable = true;
      virtualHosts."kanboard.dadada.li" = {
        root = pkgs.buildEnv {
          name = "kanboard-configured";
          paths = [
            (pkgs.runCommand "kanboard-over" {meta.priority = 0;} ''
              mkdir -p $out
              for f in index.php jsonrpc.php ; do
              echo "<?php require('$out/config.php');" > $out/$f
              tail -n+2 ${pkgs.kanboard}/share/kanboard/$f \
              | sed 's^__DIR__^"${pkgs.kanboard}/share/kanboard"^' >> $out/$f
              done
              ln -s /var/lib/kanboard $out/data
              ln -s ${./kanboard-config.php} $out/config.php
            '')
            {
              outPath = "${pkgs.kanboard}/share/kanboard";
              meta.priority = 10;
            }
          ];
        };
        locations = {
          "/".index = "index.php";
          "~ \\.php$" = {
            tryFiles = "$uri =404";
            extraConfig = ''
              fastcgi_pass unix:${config.services.phpfpm.pools.kanboard.socket};
            '';
          };
        };
      };
    };
  };
}
