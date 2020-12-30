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
    users = {
      "dadada" = [ "${keys}/dadada.pub" ];
    };
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
  boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/a28c8dd0-1824-4dd3-862c-7e0477871937";

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
