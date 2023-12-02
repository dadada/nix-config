{ config
, pkgs
, ...
}:
let
  hostName = "surgat";
in
{
  imports = [
    ./hardware-configuration.nix
    ../modules/profiles/cloud.nix
  ];

  networking.hostName = hostName;

  services.nginx = {
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    #logError = "/dev/null";
    appendHttpConfig = ''
      access_log off;
    '';
  };

  services.nginx.virtualHosts."hydra.${config.networking.domain}" = {
    enableACME = true;
    forceSSL = true;

    root = "${pkgs.nginx}/html";

    locations."/" = {
      proxyPass = "http://10.3.3.3:3000/";
      extraConfig = ''
        proxy_redirect default;
      '';
    };
  };

  dadada.element.enable = true;
  dadada.gitea.enable = true;
  dadada.miniflux.enable = true;
  dadada.weechat.enable = true;
  dadada.homePage.enable = true;
  dadada.share.enable = true;
  dadada.backupClient = {
    backup1.enable = true;
    backup2 = {
      enable = true;
      repo = "u355513-sub3@u355513-sub3.your-storagebox.de:/home/backup";
    };
  };

  services.postgresqlBackup = {
    enable = true;
    backupAll = true;
    compression = "zstd";
    location = "/var/backup/postgresql";
  };

  systemd.network = {
    enable = true;
    networks = {
      "10-wan" = {
        matchConfig.Name = "ens3";
        networkConfig.DHCP = "ipv4";
        address = [
          "49.12.3.98/32"
          "2a01:4f8:c17:1d70::/64"
        ];
        routes = [
          { routeConfig.Gateway = "fe80::1"; }
          {
            routeConfig = {
              Gateway = "172.31.1.1";
              GatewayOnLink = true;
            };
          }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
      "10-hydra" = {
        matchConfig.Name = "hydra";
        address = [ "10.3.3.1/24" ];
        DHCP = "no";
        networkConfig.IPv6AcceptRA = false;
        linkConfig.RequiredForOnline = "no";
        routes = [
          {
            routeConfig = { Destination = "10.3.3.0/24"; };
          }
        ];
      };
    };
    netdevs = {
      "10-hydra" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "hydra";
        };
        wireguardConfig = {
          PrivateKeyFile = "/var/lib/wireguard/hydra";
          ListenPort = 51235;
        };
        wireguardPeers = [{
          wireguardPeerConfig = {
            PublicKey = "Kw2HVRb1zeA7NAzBvI3UzmOj45VqM358EBuZWdlAUDE=";
            AllowedIPs = [ "10.3.3.3/32" ];
          };
        }];
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      22 # SSH
      80
      443 # HTTPS
    ];
    allowedUDPPorts = [
      51234 # Wireguard
      51235 # Wireguard
    ];
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  swapDevices = [
    {
      device = "/var/swapfile";
      size = 4096;
    }
  ];

  services.resolved = {
    enable = true;
    fallbackDns = [ "9.9.9.9" "2620:fe::fe" ];
  };

  system.autoUpgrade.allowReboot = false;

  services.postgresql.package = pkgs.postgresql_15;

  system.stateVersion = "23.05";
}
