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
in
{
  imports = [
    ../modules/profiles/server.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "ninurta";

  networking.useDHCP = false;
  networking.interfaces.enp86s0.useDHCP = true;

  networking.hosts = {
    "127.0.0.1" = hostAliases;
    "::1" = hostAliases;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # TODO enable
  # fileSystems."/mnt/storage" = {
  #   device = "/dev/disk/by-uuid/a34e36fc-d7dd-4ceb-93c4-48f9c2727cb7";
  #   mountPoint = "/mnt/storage";
  #   neededForBoot = false;
  #   options = [ "nofail" ];
  # };

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

  networking.wireguard = {
    enable = true;
    interfaces.uwupn = {
      allowedIPsAsRoutes = true;
      privateKeyFile = config.age.secrets.${wg0PrivKey}.path;
      ips = [ "10.11.0.39/32" "fc00:1337:dead:beef::10.11.0.39/128" ];
      peers = [
        {
          publicKey = "tuoiOWqgHz/lrgTcLjX+xIhvxh9jDH6gmDw2ZMvX5T8=";
          allowedIPs = [ "10.11.0.0/22" "fc00:1337:dead:beef::10.11.0.0/118" "192.168.178.0/23" ];
          endpoint = "53c70r.de:51820";
          persistentKeepalive = 25;
          presharedKeyFile = config.age.secrets.${wg0PresharedKey}.path;
        }
      ];
    };
    interfaces.hydra = {
      allowedIPsAsRoutes = true;
      privateKeyFile = config.age.secrets.${wgHydraPrivKey}.path;
      ips = [ "10.3.3.3/32" ];
      peers = [
        {
          publicKey = "KzL+PKlv4LktIqqTqC9Esw8dkSZN2qSn/vq76UHbOlY=";
          allowedIPs = [ "10.3.3.1/32" ];
          endpoint = "hydra.dadada.li:51235";
          persistentKeepalive = 25;
        }
      ];
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

  networking.networkmanager.enable = false;

  dadada.networking.localResolver.enable = true;
  dadada.networking.localResolver.uwu = true;
  dadada.networking.localResolver.s0 = true;

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

  system.stateVersion = "22.11";
}
