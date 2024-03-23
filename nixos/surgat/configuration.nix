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

  networking.useDHCP = false;

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
      "10-ninurta" = {
        matchConfig.Name = "ninurta";
        address = [ "10.3.3.1/32" "fd42:9c3b:f96d:121::1/128" ];
        DHCP = "no";
        networkConfig.IPv6AcceptRA = false;
        linkConfig.RequiredForOnline = "no";
        routes = [
          { routeConfig = { Destination = "10.3.3.3/24"; }; }
          { routeConfig = { Destination = "fd42:9c3b:f96d:121::/64"; }; }
          { routeConfig = { Destination = "fd42:9c3b:f96d:101::/64"; }; }
        ];
      };
    };
    netdevs = {
      "10-ninurta" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "ninurta";
        };
        wireguardConfig = {
          PrivateKeyFile = "/var/lib/wireguard/hydra";
          ListenPort = 51235;
        };
        wireguardPeers = [{
          wireguardPeerConfig = {
            PublicKey = "Kw2HVRb1zeA7NAzBvI3UzmOj45VqM358EBuZWdlAUDE=";
            AllowedIPs = [ "10.3.3.3/32" "fd42:9c3b:f96d:121::3/128" "fd42:9c3b:f96d:101:4a21:bff:fe3e:9cfe/128" ];
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
    interfaces.ninurta.allowedTCPPorts = [
      4949 # munin-node
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

  services.munin-node = {
    enable = true;
    extraConfig = ''
      host_name surgat
      cidr_allow 10.3.3.3/32
    '';
  };

  system.stateVersion = "23.05";
}
