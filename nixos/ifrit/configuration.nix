{ config, pkgs, lib, ... }:
let
  hostAliases = [
    "ifrit.dadada.li"
    "bs.vpn.dadada.li"
    "media.dadada.li"
    "backup.dadada.li"
  ];
  backups = "/mnt/storage/backup";
  ddns = hostname: {
    timers."ddns-${hostname}" = {
      wantedBy = [ "timers.target" ];
      partOf = [ "ddns-${hostname}.service" ];
      timerConfig.OnCalendar = "hourly";
    };
    services."ddns-${hostname}" = {
      serviceConfig.Type = "oneshot";
      script = ''
        function url() {
        echo "https://svc.joker.com/nic/update?username=$1&password=$2&hostname=$3"
        }

        IFS=':'
        read -r user password < /var/lib/ddns/credentials
        unset IFS

        curl_url=$(url "$user" "$password" ${hostname})

        ${pkgs.curl}/bin/curl -4 "$curl_url"
        ${pkgs.curl}/bin/curl -6 "$curl_url"
      '';
    };
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  dadada = {
    admin.enable = true;
    fileShare.enable = false;

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
      "fginfo" = {
        id = "6";
        key = "zadidMDiALJUHdhMrGqAa5RGjPN/x5XJ8aR5elnaeUc=";
      };
      "fginfo-git" = {
        id = "7";
        key = "5EaLm7uC8XzoN8+BaGzgGRUU4q5shM7gQJcs/d7n+Vo=";
      };
    };
  };

  users.users.borg.home = "/mnt/storage/backup";
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
  networking.domain = "dadada.li";

  networking.hosts = {
    "127.0.0.1" = hostAliases;
    "::1" = hostAliases;
  };

  # weird issues with crappy plastic router
  networking.interfaces."ens3".tempAddress = "disabled";

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
    ];
    allowedUDPPorts = [
      51234
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

  environment.systemPackages = [ pkgs.curl ];

  systemd = (ddns "bs.vpn.dadada.li") // (ddns "backup0.dadada.li");

  system.stateVersion = "20.03";
}
