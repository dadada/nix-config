{ config, pkgs, lib, ... }:
let
  hostAliases = [
    "ifrit.dadada.li"
    "media.dadada.li"
    "backup1.dadada.li"
  ];
  secretsPath = config.dadada.secrets.path;
  wg0PrivKey = "pruflas-wg0-key";
  wgHydraPrivKey = "pruflas-wg-hydra-key";
  wg0PresharedKey = "pruflas-wg0-preshared-key";
  hydraGitHubAuth = "hydra-github-authorization";
  initrdSshKey = "/etc/ssh/ssh_initrd_ed25519_key";
in
{
  imports = [
    ../modules/profiles/server.nix
    ./hardware-configuration.nix
  ];

  dadada.backupClient.bs.enable = false;

  networking.hostName = "ninurta";
  networking.domain = "bs.dadada.li";

  networking.hosts = {
    "127.0.0.1" = hostAliases;
    "::1" = hostAliases;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  assertions = lib.singleton {
    assertion = (config.boot.initrd.network.ssh.hostKeys != [ ]) -> config.boot.loader.supportsInitrdSecrets == true;
    message = "Refusing to store private keys in store";
  };

  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    network = {
      enable = true;
      flushBeforeStage2 = true;
      ssh = {
        enable = true;
        port = 2222;
        authorizedKeys = config.dadada.admin.users.dadada.keys;
        hostKeys = [ initrdSshKey ];
      };
    };
    systemd = {
      enable = true;
      network = {
        enable = true;
        links = {
          "10-lan" = {
            matchConfig.Name = "e*";
            linkConfig.MACAddressPolicy = "persistent";
          };
        };
        networks = {
          "10-lan" = {
            matchConfig.Name = "e*";
            networkConfig.DHCP = "ipv4";
            linkConfig.RequiredForOnline = "routable";
          };
        };
      };
    };
  };

  dadada.ddns.domains = [ "backup1.dadada.li" ];

  dadada.borgServer = {
    enable = true;
    path = "/mnt/storage/backups";
  };

  services.borgbackup.jobs."backup1.bs.dadada.li" = {
    removableDevice = true;
    paths = [
      "/var/backup"
      "/var/lib"
      "/var/www"
      "/home"
    ];
    exclude = [
      "/home/*/.cache"
      "/var/lib/machines"
    ];
    repo = "/mnt/storage/backups/${config.networking.hostName}";
    doInit = true;
    encryption = {
      mode = "repokey";
      passCommand = "cat ${config.age.secrets.ninurta-backup-passphrase.path}";
    };
    compression = "auto,lz4";
    prune.keep = {
      within = "1d"; # Keep all archives from the last day
      daily = 7;
      weekly = 2;
      monthly = -1; # Keep at least one archive for each month
      yearly = -1; # Keep at least one archive for each year
    };
    startAt = "daily";
  };

  services.postgresqlBackup = {
    enable = true;
    backupAll = true;
    compression = "zstd";
    location = "/var/backup/postgresql";
  };

  age.secrets."ninurta-backup-passphrase" = {
    file = "${secretsPath}/ninurta-backup-passphrase.age";
    mode = "400";
  };

  age.secrets.${hydraGitHubAuth} = {
    file = "${secretsPath}/${hydraGitHubAuth}.age";
    mode = "440";
    owner = "hydra-www";
    group = "hydra";
  };

  services.hydra = {
    enable = true;
    package = pkgs.hydra-unstable;
    hydraURL = "https://hydra.dadada.li";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [ ];
    useSubstitutes = true;
    port = 3000;
    listenHost = "10.3.3.3";
    extraConfig = ''
      Include ${config.age.secrets."${hydraGitHubAuth}".path}

      <githubstatus>
        jobs = nix-config:main.*
        inputs = nix-config
        excludeBuildFromContext = 1
        useShortContext = 1
      </githubstatus>
    '';
  };

  nix.buildMachines = [
    {
      hostName = "localhost";
      system = "x86_64-linux";
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
      maxJobs = 16;
    }
  ];

  nix.extraOptions = ''
    allowed-uris = https://github.com/NixOS https://github.com/nix-community https://github.com/dadada https://git.dadada.li/ github.com/ryantm/agenix github.com/serokell/deploy-rs https://gitlab.com/khumba/nvd.git https://github.com/real-or-random/dokuwiki-plugin-icalevents https://github.com/giterlizzi/dokuwiki-template-bootstrap3
  '';

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    logError = "/dev/null";
    appendHttpConfig = ''
      access_log off;
    '';

    virtualHosts."pruflas.uwu" = {
      enableACME = false;
      forceSSL = false;
      root = "/var/www/pruflas.uwu";
      locations."/" = {
        tryFiles = "$uri $uri/ = 404";
        index = "index.txt";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/www/pruflas.uwu 0551 nginx nginx - -"
    "d /mnt/storage/backups/ninurta 0750 ${config.users.users.borg.name} ${config.users.users.borg.group} - -"
  ];

  age.secrets.${wg0PrivKey} = {
    file = "${secretsPath}/${wg0PrivKey}.age";
    owner = "systemd-network";
  };
  age.secrets.${wg0PresharedKey} = {
    file = "${secretsPath}/${wg0PresharedKey}.age";
    owner = "systemd-network";
  };
  age.secrets.${wgHydraPrivKey} = {
    file = "${secretsPath}/${wgHydraPrivKey}.age";
    owner = "systemd-network";
  };

  # This does not work, since the key is needed earlier than run-agenix.mount.
  # age.secrets.${initrdSshKey} = {
  #   file = "${secretsPath}/${initrdSshKey}.age";
  #   mode = "700";
  # };

  services.snapper = {
    cleanupInterval = "1d";
    snapshotInterval = "hourly";
    configs.var = {
      SUBVOLUME = "/var";
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = 24;
      TIMELINE_LIMIT_DAILY = 13;
      TIMELINE_LIMIT_WEEKLY = 6;
      TIMELINE_LIMIT_MONTHLY = 3;
    };
    configs.storage = {
      SUBVOLUME = "/mnt/storage";
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = 24;
      TIMELINE_LIMIT_DAILY = 13;
      TIMELINE_LIMIT_WEEKLY = 6;
      TIMELINE_LIMIT_MONTHLY = 3;
    };
  };

  services.smartd.enable = true;

  systemd.network = {
    enable = true;
    links = {
      "10-lan" = {
        matchConfig.Name = "enp*";
        linkConfig.MACAddressPolicy = "persistent";
      };
    };
    networks = {
      "10-wlan" = {
        matchConfig.Name = "wlan*";
        linkConfig.RequiredForOnline = false;
      };
      "10-wlo" = {
        matchConfig.Name = "wlo*";
        linkConfig.RequiredForOnline = false;
      };
      "10-lan" = {
        matchConfig.Name = "enp*";
        networkConfig.DHCP = "ipv4";
        linkConfig.RequiredForOnline = "routable";
      };
      "10-hydra" = {
        matchConfig.Name = "hydra";
        address = [ "10.3.3.3/24" ];
        DHCP = "no";
        networkConfig.IPv6AcceptRA = false;
        linkConfig.RequiredForOnline = false;
        routes = [
          { routeConfig = { Gateway = "10.3.3.1"; Destination = "10.3.3.3/32"; }; }
        ];
      };
      "10-uwu" = {
        matchConfig.Name = "uwu";
        address = [ "10.11.0.39/24" "fc00:1337:dead:beef::10.11.0.39/128" ];
        dns = [ "10.11.0.1::%uwu#uwu" ];
        domains = [ "uwu" ];
        DHCP = "no";
        networkConfig.IPv6AcceptRA = false;
        linkConfig.RequiredForOnline = false;
        routes = [
          { routeConfig = { Destination = "10.11.0.0/22"; }; }
          { routeConfig = { Destination = "fc00:1337:dead:beef::10.11.0.0/118"; }; }
        ];
      };
    };
    netdevs = {
      "10-hydra" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "hydra";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.${wgHydraPrivKey}.path;
          ListenPort = 51235;
        };
        wireguardPeers = [{
          wireguardPeerConfig = {
            PublicKey = "KzL+PKlv4LktIqqTqC9Esw8dkSZN2qSn/vq76UHbOlY=";
            AllowedIPs = [ "10.3.3.1/32" ];
            PersistentKeepalive = 25;
          };
        }];
      };
      "10-uwu" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "uwu";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.${wg0PrivKey}.path;
        };
        wireguardPeers = [{
          wireguardPeerConfig = {
            PublicKey = "tuoiOWqgHz/lrgTcLjX+xIhvxh9jDH6gmDw2ZMvX5T8=";
            AllowedIPs = [ "10.11.0.0/22" "fc00:1337:dead:beef::10.11.0.0/118" "192.168.178.0/23" ];
            PersistentKeepalive = 25;
            PresharedKeyFile = config.age.secrets.${wg0PresharedKey}.path;
            Endpoint = "53c70r.de:51820";
          };
        }];
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      22 # SSH
      80 # HTTP
      443 # HTTPS
      3000 # Hydra
    ];
    allowedUDPPorts = [
      51234 # Wireguard
      51235 # Wireguard
    ];
  };

  services.resolved.enable = true;
  networking.networkmanager.enable = false;

  # Desktop things for media playback

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverridePackages = with pkgs; [ gnome3.gnome-settings-daemon ];
    extraGSettingsOverrides = ''
      [org.gnome.desktop.screensaver]
      lock-delay=uint32 30
      lock-enabled=true

      [org.gnome.desktop.session]
      idle-delay=uint32 0

      [org.gnome.settings-daemon.plugins.power]
      idle-dim=false
      power-button-action='interactive'
      power-saver-profile-on-low-battery=false
      sleep-inactive-ac-type='nothing'
      sleep-inactive-battery-type='nothing'
    '';
  };



  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    # powertop autotune
    powertop.enable = true;
    # This generally means no power management for SCSI
    scsiLinkPolicy = "med_power_with_dipm";
    # Configure the disks to spin down after 10 min of inactivity.
    powerUpCommands = ''
      find /dev -regextype sed -regex '/dev/sd[a-z]$' | xargs ${pkgs.hdparm}/sbin/hdparm -S 120
    '';
    powerDownCommands = ''
      find /dev -regextype sed -regex '/dev/sd[a-z]$' | xargs ${pkgs.hdparm}/sbin/hdparm -S 0
    '';
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.pulseaudio.enable = false;

  environment.systemPackages = with pkgs; [
    firefox
    spotify
    mpv
    smartmontools
    hdparm
  ];

  users.users."media" = {
    isNormalUser = true;
    description = "Media playback user";
    extraGroups = [ "users" "video" ];
    # allow anyone with physical access to log in
    password = "media";
  };

  documentation.enable = true;
  documentation.nixos.enable = true;

  system.stateVersion = "23.05";
}
