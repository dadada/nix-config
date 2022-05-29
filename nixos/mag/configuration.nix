{ config, pkgs, lib, ... }:
let
  hostAliases = [
    "mag.dadada.li"
    "vpn.dadada.li"
  ];
in
{
  imports = [
#    ./hardware-configuration.nix
  ];

  dadada = {
    admin.enable = true;
    vpnServer = {
      enable = true;
      peers = {
        "morax" = {
          id = "2";
          key = "Lq5QLGoI3r3BXEJ72dWH9UTmY/8uaYRPLQB5WWHqJUE=";
        };
        "gorgon" = {
          id = "3";
          key = "0eWP1hzkyoXlrjPSOq+6Y1u8tnFH+SejBJs8f8lf+iU=";
        };
        "surgat" = {
          id = "4";
          key = "+paiOqOITdLy3oqoI2DhOj4k8gncAcjFLkJrxJl0iBE=";
        };
        "pruflas" = {
          id = "5";
          key = "o8B8rTA+u5XOJK4JI+TRCFjVJn/3T7UofLqFRIPoNQk=";
        };
      };
    };
    ddns.domains = [
      "vpn.dadada.li"
    ];
  };

  networking.hostName = "mag";

  networking.hosts = {
    "127.0.0.1" = hostAliases;
    "::1" = hostAliases;
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.interfaces."ens3".tempAddress = "disabled";

  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

  boot.kernelParams = [
    "console=ttyS0,115200"
  ];

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      22 # SSH
    ];
    allowedUDPPorts = [
      51234
    ];
  };

  system.stateVersion = "22.05";
}
