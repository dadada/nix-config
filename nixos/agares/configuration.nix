{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  dadada = {
    admin.enable = true;
    networking.localResolver.enable = true;
  };

  networking.hostName = "agares";
  networking.domain = "dadada.li";

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  boot.kernelParams = [
    "console=ttyS0,115200"
    "amd_iommu=on"
  ];

  networking.interfaces.enp2s0.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = false;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      22 # SSH
    ];
  };

  virtualisation.libvirtd.enable = true;

  environment.systemPackages = [ pkgs.curl ];

  system.stateVersion = "22.05";
}
