{ config
, pkgs
, lib
, ...
}:
let
  hostName = "surgat";
in
{
  imports = [
    ./hardware-configuration.nix
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
    bs.enable = true;
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

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.interfaces."ens3".ipv6.addresses = [
    {
      address = "2a01:4f8:c17:1d70::";
      prefixLength = 64;
    }
  ];

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
        publicKey = "Kw2HVRb1zeA7NAzBvI3UzmOj45VqM358EBuZWdlAUDE=";
        allowedIPs = [ "10.3.3.3/32" ];
        persistentKeepalive = 25;
      }
    ];
  };

  system.stateVersion = "20.09";
}
