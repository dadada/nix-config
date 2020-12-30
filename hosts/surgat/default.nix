{ config, pkgs, lib, ... }:
let
  hostName = "surgat";
  this = import ../.. {};
  keys = ../../pkgs/keys/keys;
in {
  imports = [ this.profiles.base ];

  networking.hostName = hostName;

  dadada.admin = {
    enable = true;
    users = [ "dadada" ];
  };

  dadada.networking.vpnExtension = "4";
  dadada.weechat.enable = true;

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
  boot.loader.grub.device = "/dev/disk/by-uuid/6e37ff6b-8cec-4d07-80d5-cd28651522ae";

  # TODO
  # backup

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
