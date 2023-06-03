{ config, pkgs, lib, ... }:
let
  hostAliases = [
    "ifrit.dadada.li"
    "media.dadada.li"
    "backup0.dadada.li"
  ];
  secretsPath = config.dadada.secrets.path;
  wg0PrivKey = "${config.networking.hostName}-wg0-key";
  wgHydraPrivKey = "${config.networking.hostName}-wg-hydra-key";
  wg0PresharedKey = "${config.networking.hostName}-wg0-preshared-key";
  hydraGitHubAuth = "hydra-github-authorization";
  initrdPrivateKey = "/etc/ssh/initrd_ssh_host_ed25519_key";
in
{
  imports = [
    ../modules/profiles/server.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "ninurta";

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

  boot.initrd = {
    network = {
      enable = true;
      flushBeforeStage2 = true;
      ssh = {
        enable = true;
        port = 2222;
        authorizedKeys = config.dadada.admin.users.dadada.keys;
        hostKeys = [ initrdPrivateKey ];
      };
    };
    systemd = {
      enable = true;
      network = {
        enable = true;
        networks = {
          "10-lan-enp" = {
            matchConfig.Name = "enp*";
            networkConfig.DHCP = "ipv4";
            linkConfig.RequiredForOnline = "routable";
          };
          "10-lan-eth" = {
            matchConfig.Name = "eth*";
            networkConfig.DHCP = "ipv4";
            linkConfig.RequiredForOnline = "routable";
          };
          "10-lan-ens" = {
            matchConfig.Name = "ens*";
            networkConfig.DHCP = "ipv4";
            linkConfig.RequiredForOnline = "routable";
          };
        };
      };
    };
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/a34e36fc-d7dd-4ceb-93c4-48f9c2727cb7";
    mountPoint = "/mnt/storage";
    neededForBoot = false;
    options = [ "nofail" ];
  };

  # TODO enable
  # dadada.borgServer = {
  #   enable = true;
  #   path = "/mnt/storage/backup";
  # };

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
        index = "index.html";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/www/pruflas.uwu 0551 nginx nginx - -"
  ];

  age.secrets.${wg0PrivKey}.file = "${secretsPath}/${wg0PrivKey}.age";
  age.secrets.${wg0PresharedKey}.file = "${secretsPath}/${wg0PresharedKey}.age";
  age.secrets.${wgHydraPrivKey}.file = "${secretsPath}/${wgHydraPrivKey}.age";

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
      "10-lan" = {
        matchConfig.Name = "enp*";
        networkConfig.DHCP = "ipv4";
        linkConfig.RequiredForOnline = "routable";
      };
      "10-hydra" = {
        matchConfig.Name = "hydra";
        address = [ "10.3.3.1/24" ];
        DHCP = "no";
        networkConfig.IPv6AcceptRA = false;
        linkConfig.RequiredForOnline = "no";
        routes = [
          { routeConfig = { Gateway = "10.3.3.3"; Destination = "10.3.3.3/32"; }; }
        ];
      };
      "10-uwu" = {
        matchConfig.Name = "uwu";
        address = [ "10.11.0.39/24" "fc00:1337:dead:beef::10.11.0.39/128" ];
        DHCP = "no";
        networkConfig.IPv6AcceptRA = false;
        linkConfig.RequiredForOnline = "no";
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
  services.xserver.desktopManager.gnome.enable = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.pulseaudio.enable = false;

  environment.systemPackages = [ pkgs.firefox pkgs.spotify pkgs.mpv ];

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
