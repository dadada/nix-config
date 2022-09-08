{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/767a84ad-4157-4e9f-a3db-145449edd3bc";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/0494-CB52";
      fsType = "vfat";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/767a84ad-4157-4e9f-a3db-145449edd3bc";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/767a84ad-4157-4e9f-a3db-145449edd3bc";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/767a84ad-4157-4e9f-a3db-145449edd3bc";
    fsType = "btrfs";
    options = [ "subvol=swap" "noatime" ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
