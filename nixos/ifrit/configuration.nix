{ config, pkgs, lib, ... }:
let
  hostAliases = [
    "ifrit.dadada.li"
    "media.dadada.li"
    "backup0.dadada.li"
  ];
  backups = "/mnt/storage/backup";
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  dadada = {
    admin.enable = true;
    ddns.domains = [
      "backup0.dadada.li"
    ];
  };

  users.users.borg.home = backups;
  services.borgbackup.repos = {
    "metis" = {
      allowSubRepos = false;
      authorizedKeysAppendOnly = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDnc1gCi8lbhlLmPKvaExtCxVaAni8RrOuHUQO6wTbzR root@metis" ];
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyTgdVPPxQeL5KZo9frZQlDIv2QkelJw3gNGoGtUMfw tim@metis" ];
      path = "${backups}/metis";
      quota = "1T";
    };
    "gorgon" = {
      allowSubRepos = false;
      authorizedKeysAppendOnly = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP6p9b2D7y2W+9BGee2yk2xsCRewNNaE6oS3CqlW61ti root@gorgon" ];
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyTgdVPPxQeL5KZo9frZQlDIv2QkelJw3gNGoGtUMfw tim@metis" ];
      path = "${backups}/gorgon";
      quota = "1T";
    };
    "surgat" = {
      allowSubRepos = false;
      authorizedKeysAppendOnly = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGhatanrNG+M6jAkU7Yi44mJmTreJkqyZ6Z+qiEgV7O root@surgat" ];
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyTgdVPPxQeL5KZo9frZQlDIv2QkelJw3gNGoGtUMfw tim@metis" ];
      path = "${backups}/surgat";
      quota = "50G";
    };
    "pruflas" = {
      allowSubRepos = false;
      authorizedKeysAppendOnly = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBk7f9DSnXCOIUsxFsjCKG23vHShV4TSzzPJunPOwa1I root@pruflas" ];
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyTgdVPPxQeL5KZo9frZQlDIv2QkelJw3gNGoGtUMfw tim@metis" ];
      path = "${backups}/pruflas";
      quota = "50G";
    };
    "wohnzimmerpi" = {
      allowSubRepos = false;
      authorizedKeysAppendOnly = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK6uZ8mPQJWOL984gZKKPyxp7VLcxk42TpTh5iPP6N6k root@wohnzimmerpi" ];
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyTgdVPPxQeL5KZo9frZQlDIv2QkelJw3gNGoGtUMfw tim@metis" ];
      path = "${backups}/wohnzimmerpi";
      quota = "50G";
    };
    "fginfo" = {
      allowSubRepos = false;
      authorizedKeysAppendOnly = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxsyJeZVlVix0FPE8S/Gx0DVutS1ZNESVdYvHBwo36wGlYpSsQoSy/2HSwbpxs88MOGw1QNboxvvpBxCWxZ5HyjxuO5SwYgtmpjPXvmqfVqNXXnLChhSnKgk9b+HesQJCbHyrF9ZAJXEFCOGhOL3YTgd6lTX3lQUXgh/LEDlrPrigUMDNPecPWxpPskP6Vvpe9u+duhL+ihyxXaV+CoPk8nkWrov5jCGPiM48pugbwAfqARyZDgFpmWwL7Xg2UKgVZ1ttHZCWwH+htgioVZMYpdkQW1aq6LLGwN34Hj2VKXzmJN5frh6vQoZr2AFGHNKyJwAMpqnoY//QwuREpZTrh root@fginfo.ibr.cs.tu-bs.de" ];
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyTgdVPPxQeL5KZo9frZQlDIv2QkelJw3gNGoGtUMfw tim@metis" ];
      path = "${backups}/fginfo";
      quota = "10G";
    };
    "fginfo-git" = {
      allowSubRepos = false;
      authorizedKeysAppendOnly = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmI6cUv3j0T9ofFB286sDwXwwczqi41cp4MZyGH3VWQnqBPNjICqAdY3CLhgvGBCxSe6ZgKQ+5YLsGSSlU1uhrJXW2UiVKuIPd0kjMF/9e8hmNoTTh0pdk9THfz9LLAdI1vPin1EeVReuDXlZkCI7DFYuTO9yiyZ1uLZUfT1KBRoqiqyypZhut7zT3UaDs2L+Y5hho6WiTdm7INuz6HEB7qYXzrmx93hlcuLZA7fDfyMO9F4APZFUqefcUIEyDI2b+Q/8Q2/rliT2PoC69XLVlj7HyVhfgKsOnopwBDNF3rRcJ6zz4WICPM18i4ZCmfoDTL/cFr5c41Lan1X7wS5wR root@fginfo-git" ];
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyTgdVPPxQeL5KZo9frZQlDIv2QkelJw3gNGoGtUMfw tim@metis" ];
      path = "${backups}/fginfo-git";
      quota = "10G";
    };
  };

  networking.hostName = "ifrit";

  networking.hosts = {
    "127.0.0.1" = hostAliases;
    "::1" = hostAliases;
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
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
    allowedUDPPorts = [
      51234
    ];
  };

  users.users."mist" = {
    isNormalUser = true;
  };

  environment.systemPackages = [ pkgs.curl ];

  system.stateVersion = "20.03";
}
