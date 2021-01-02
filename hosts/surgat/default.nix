{ config, pkgs, lib, ... }:
let
  hostName = "surgat";
  this = import ../.. { inherit pkgs; };
in
{
  imports = [ this.profiles.base ];

  networking.hostName = hostName;

  services.nginx = {
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    logError = "/dev/null";
    appendHttpConfig = ''
      access_log off;
    '';
  };

  services.nginx.virtualHosts."hydra.${config.networking.domain}" = {
    enableACME = true;
    forceSSL = true;

    locations."/".extraConfig = ''
      proxy_pass http://10.3.3.3:3000/;
      proxy_redirect http://10.3.3.3:3000 https://hydra.dadada.li/;
      proxy_set_header  X-Real-IP         $remote_addr;
      proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
      proxy_set_header  X-Forwarded-Proto $scheme;
      proxy_set_header  X-Request-Base    /;
    '';
  };

  dadada.admin = {
    enable = true;
    users = {
      "dadada" = [ "${pkgs.dadadaKeys}/dadada.pub" ];
    };
  };

  dadada.element.enable = true;
  dadada.gitea.enable = true;
  dadada.networking.vpnExtension = "4";
  dadada.weechat.enable = true;
  dadada.homePage.enable = true;
  dadada.share.enable = true;
  dadada.backupClient = {
    enable = true;
    bs = true;
  };

  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

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

  security.acme = {
    email = "d553a78d-0349-48db-9c20-5b27af3a1dfc@dadada.li";
    acceptTerms = true;
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.interfaces."ens3".ipv6.addresses = [{
    address = "2a01:4f8:c17:1d70::";
    prefixLength = 64;
  }];

  networking.defaultGateway6 = {
    address = "fe80::1";
    interface = "ens3";
  };

  #boot.initrd.network.ssh = {
  #  enable = true;
  #  port = 22;
  #  authorizedKeys = "${keys}/dadada.pub";
  #  hostKeys = [
  #  ];
  #};

  swapDevices = [
    {
      device = "/var/swapfile";
      size = 4096;
    }
  ];

  networking.wireguard.interfaces."hydra" = {
    ips = [ "10.3.3.1/24" ];
    listenPort = 51235;

    privateKeyFile = "/var/lib/wireguard/hydra";

    peers = [
      {
        publicKey = "CTKwL6+SJIqKXr1DIHejMDgjoxlWPaT78Pz3+JqcNlw=";
        allowedIPs = [ "10.3.3.3/32" ];
        persistentKeepalive = 25;
      }
    ];
  };
}
