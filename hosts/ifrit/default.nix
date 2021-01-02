{ config, pkgs, lib, ... }:
let
  hostAliases = [
    "ifrit.dadada.li"
    "bs.vpn.dadada.li"
    "media.dadada.li"
    "media.local"
  ];
  backups = "/mnt/storage/backup";
in
{
  imports = [
    ../../modules/profiles/base
  ];

  dadada = {
    admin.enable = true;
    fileShare.enable = true;

    vpnServer.enable = true;
    vpnServer.peers = {
      "metis" = {
        id = "1";
        key = "u+HCYDbK0zwbIEfGf+LVQErlJ0vchf5ZYj0N93NB5ns=";
      };
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
  };

  networking.hostName = "ifrit";
  networking.domain = "dadada.li";

  networking.hosts = {
    "127.0.0.1" = hostAliases;
    "::1" = hostAliases;
  };

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

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
      80
      443 # HTTP(S)
      111
      2049 # NFS
      137
      138
      139
      445 # SMB
    ];
    allowedUDPPorts = [
      137
      138
      139
      445 # SMB
      111
      2049 # NFS
      51234 # Wireguard
    ];
  };

  security.acme = {
    email = "d553a78d-0349-48db-9c20-5b27af3a1dfc@dadada.li";
    acceptTerms = true;
    #  certs."webchat.dadada.li" = {
    #    credentialsFile = "/var/lib/lego/acme-joker.env";
    #    dnsProvider = "joker";
    #    postRun = "systemctl reload nginx.service";
    #  };
    #  certs."weechat.dadada.li" = {
    #    credentialsFile = "/var/lib/lego/acme-joker.env";
    #    dnsProvider = "joker";
    #    postRun = "systemctl reload nginx.service";
    #  };
  };

  users.users."mist" = {
    isNormalUser = true;
  };

  services.avahi = {
    enable = false;
    publish = {
      enable = true;
      addresses = true;
      workstation = false;
    };
  };
}
