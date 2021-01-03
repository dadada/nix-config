{ config, pkgs, lib, ... }:
let
  hostName = "pruflas";
  this = import ../.. { inherit pkgs; };
  logo = builtins.fetchurl {
    sha256 = "1c8y19a3yz4g9dl7hbx7aq4y92jfxl4nrsparzyzwn0wcm9jan27";
    url = "https://openmoji.org/php/download_from_github.php?emoji_hexcode=1F431-200D-1F4BB&emoji_variant=color";
    name = "open-moji-hack-cat";
  };
in
{
  imports = [ this.profiles.base ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking.hostName = hostName;
  networking.hosts = {
    "10.3.3.3" = [ "hydra.dadada.li" ];
  };

  services.logind.lidSwitch = "ignore";

  services.hydra = {
    enable = true;
    package = pkgs.hydra-unstable;
    hydraURL = "https://hydra.dadada.li";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [ ];
    useSubstitutes = true;
    listenHost = "hydra.dadada.li";
    port = 3000;
    logo = logo;
  };

  nix.buildMachines = [
    {
      hostName = "localhost";
      system = "x86_64-linux";
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
      maxJobs = 8;
    }
  ];

  services.nginx = {
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    logError = "/dev/null";
    appendHttpConfig = ''
      access_log off;
    '';
  };

  dadada.admin = {
    enable = true;
    users = {
      "dadada" = [ "${pkgs.dadadaKeys}/dadada.pub" ];
    };
  };

  dadada.networking.vpnExtension = "5";
  dadada.backupClient = {
    enable = true;
    bs = true;
  };

  networking.useDHCP = false;
  networking.interfaces."enp0s25".useDHCP = true;

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      22 # SSH
      80
      443 # HTTPS
      3000 # Hydra
    ];
    allowedUDPPorts = [
      51234 # Wireguard
      51235 # Wireguard
    ];
  };

  security.acme = {
    email = "d553a78d-0349-48db-9c20-5b27af3a1dfc@dadada.li";
    acceptTerms = true;
  };

  boot.kernelModules = [ "kvm-intel" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  swapDevices = [
    {
      device = "/var/swapfile";
      size = 32768;
    }
  ];


  networking.wireguard.interfaces."hydra" = {
    ips = [ "10.3.3.3/24" ];
    listenPort = 51235;

    privateKeyFile = "/var/lib/wireguard/hydra";

    peers = [
      {
        publicKey = "KzL+PKlv4LktIqqTqC9Esw8dkSZN2qSn/vq76UHbOlY=";
        allowedIPs = [ "10.3.3.1/32" ];
        endpoint = "surgat.dadada.li:51235";
        persistentKeepalive = 25;
      }
    ];
  };
}
