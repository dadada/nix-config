{ config, pkgs, lib, ... }:
with lib;
{
  networking.hostName = "pruflas";

  services.logind.lidSwitch = "ignore";

  dadada.admin.enable = true;

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

  system.stateVersion = "20.09";
}
