{ config, pkgs, lib, ... }:
let
  hostName = "pruflas";
  this = import ../.. { inherit pkgs; };
in
{
  imports = [ this.profiles.base ];

  networking.hostName = hostName;

  services.hydra = {
    enable = true;
    hydraURL = "hydra.dadada.li";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [ ];
    useSubstitutes = true;
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
  networking.interfaces.ens3.useDHCP = true;

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      22 # SSH
      80
      443 # HTTPS
    ];
    allowedUDPPorts = [
      51234 # Wireguard
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
}
