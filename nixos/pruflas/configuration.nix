{ config
, pkgs
, lib
, admins
, ...
}:
with lib; {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "pruflas";

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

  dadada.admin.enable = true;
  dadada.admin.users = admins;

  dadada.backupClient = {
    bs.enable = true;
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

  environment.systemPackages = [ pkgs.spotify pkgs.mpv ];

  users.users."media" = {
    isNormalUser = true;
    description = "Media playback user";
    extraGroups = [ "users" "video" ];
  };

  networking.domain = "dadada.li";
  networking.tempAddresses = "disabled";

  users.mutableUsers = true;

  dadada.networking.localResolver.enable = true;

  dadada.autoUpgrade.enable = mkDefault true;

  documentation.enable = false;
  documentation.nixos.enable = false;

  services.journald.extraConfig = ''
    SystemKeepFree = 2G
  '';

  system.stateVersion = "20.09";
}
