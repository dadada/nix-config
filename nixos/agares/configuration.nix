{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ../modules/profiles/server.nix
    ./hardware-configuration.nix
  ];

  # to be able to use qemu from substituter
  environment.noXlibs = false;

  # libvirtd
  security.polkit.enable = true;

  dadada = {
    admin.enable = true;
    networking.localResolver.enable = true;
  };

  services.smartd.enable = true;

  networking.hostName = "agares";
  networking.domain = "bs.dadada.li";

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  boot.kernelParams = [
    "console=ttyS0,115200"
    "amd_iommu=on"
    "iommu=pt"
  ];

  boot.kernelModules = [
    "kvm-amd"
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
    "vfio_virqfd"
  ];

  networking.vlans = {
    lan = {
      id = 11;
      interface = "enp1s0";
    };
    backup = {
      id = 13;
      interface = "enp1s0";
    };
  };

  networking.bridges = {
    "br-lan" = {
      interfaces = [ "lan" ];
    };
    "br-backup" = {
      interfaces = [ "backup" ];
    };
  };

  networking.interfaces.enp1s0.useDHCP = true;

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      22 # SSH
    ];
  };

  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    flashrom
    dmidecode
  ];

  # Running router VM. They have to be restarted in the right order, so network comes up cleanly. Not ideal.
  system.autoUpgrade.allowReboot = false;

  system.stateVersion = "22.05";
}
