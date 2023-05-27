{ config
, pkgs
, lib
, ...
}:
let
  hostAliases = [
    "ifrit.dadada.li"
    "media.dadada.li"
    "backup0.dadada.li"
  ];
in
{
  dadada = {
    admin.enable = true;
    borgServer.enable = true;
    borgServer.path = "/mnt/storage/backup";
  };

  networking.hostName = "ifrit";

  networking.hosts = {
    "127.0.0.1" = hostAliases;
    "::1" = hostAliases;
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # weird issues with crappy plastic router
  networking.interfaces."ens3".tempAddress = "disabled";

  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

  boot.kernelParams = [
    "console=ttyS0,115200"
  ];

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/a34e36fc-d7dd-4ceb-93c4-48f9c2727cb7";
    mountPoint = "/mnt/storage";
    neededForBoot = false;
    options = [ "nofail" ];
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      22 # SSH
    ];
  };

  users.users."mist" = {
    isNormalUser = true;
  };

  environment.systemPackages = [ pkgs.curl ];

  services.smartd.enable = true;

  system.stateVersion = "20.03";
}
