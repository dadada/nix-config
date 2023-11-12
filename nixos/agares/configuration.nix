{ config
, modulesPath
, pkgs
, ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./ddns.nix
    ./dns.nix
    ./firewall.nix
    ../modules/profiles/server.nix
    ./network.nix
    ./ntp.nix
    ./ppp.nix
  ];

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  #fileSystems."/nix/store" = {
  #  device = "/dev/sda1";
  #  fsType = "btrfs";
  #  options = [ "subvol=/root/nix" "noatime" ];
  #};

  fileSystems."/swap" = {
    device = "/dev/sda1";
    fsType = "btrfs";
    options = [ "subvol=/root/swap" "noatime" ];
  };

  #swapDevices = [{
  #  device = "/swap/swapfile";
  #  size = 32 * 1024; # 32 GByte
  #}];

  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  dadada = {
    admin.enable = true;
  };

  services.smartd.enable = true;

  networking.hostName = "agares";
  networking.domain = "bs.dadada.li";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "ehci_pci" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.extraConfig = "
    serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
    terminal_input serial
    terminal_output serial
  ";

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

  environment.systemPackages = with pkgs; [
    curl
    flashrom
    dmidecode
    tcpdump
  ];

  # Running router VM. They have to be restarted in the right order, so network comes up cleanly. Not ideal.
  system.autoUpgrade.allowReboot = false;

  system.stateVersion = "23.05";
}
