# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "igc" "xhci_pci" "thunderbolt" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/7ca5fd2a-2a56-48fe-bd48-1e51b6a66714";
      fsType = "btrfs";
      options = [ "compress=zstd" ];
    };

  boot.initrd.luks.devices."luks".device = "/dev/disk/by-uuid/bac4ee0e-e393-414f-ac3e-1ec20739abae";

  fileSystems."/swap" =
    {
      device = "/dev/disk/by-uuid/7ca5fd2a-2a56-48fe-bd48-1e51b6a66714";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/7ca5fd2a-2a56-48fe-bd48-1e51b6a66714";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress=zstd" ];
    };

  fileSystems."/var" =
    {
      device = "/dev/disk/by-uuid/7ca5fd2a-2a56-48fe-bd48-1e51b6a66714";
      fsType = "btrfs";
      options = [ "subvol=var" "compress=zstd" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/7ca5fd2a-2a56-48fe-bd48-1e51b6a66714";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };

  fileSystems."/root" =
    {
      device = "/dev/disk/by-uuid/7ca5fd2a-2a56-48fe-bd48-1e51b6a66714";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/2E20-49CB";
      fsType = "vfat";
    };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 32 * 1024; # 32 GByte
  }];

  # TODO systemd networkd
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp86s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
