{ config, pkgs, lib, ... }:
let
  hostName = "surgat";
  this = import ../.. {};
  keys = ../../pkgs/keys/keys;
  homePage = self: super: { homePage = super.callPackage ../../pkgs/homePage {}; };
in {
  imports = [ this.profiles.base ];

  nixpkgs.overlays = [
    homePage
  ];

  networking.hostName = hostName;

  services.nginx = {
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    logError = "off";
    appendConfig = ''
      access_log off;
    '';
  };

  dadada.admin = {
    enable = true;
    users = {
      "dadada" = [ "${keys}/dadada.pub" ];
    };
  };

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
      80 443 # HTTPS
    ];
    allowedUDPPorts = [
      51234 # Wireguard
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

  networking.interfaces."ens3".ipv6.addresses = [ {
    address = "2a01:4f8:c17:1d70::";
    prefixLength = 64;
  } ];

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
}
