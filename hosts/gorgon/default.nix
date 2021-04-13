{ config, pkgs, lib, ... }:
let
  this = import ../.. { inherit pkgs; };
  nixos-hardware = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixos-hardware/archive/c242378e63b0ec334e964ac0c0fbbdd2b3e89ebf.tar.gz";
    sha256 = "1z4cr5gsyfdpcy31vqg4ikalbxmnnac6jjk1nl8mxj0h0ix7pp36";
  };
in
{
  imports = (lib.attrValues this.modules) ++ [
    ../../modules/profiles/laptop
    "${nixos-hardware}/lenovo/thinkpad/t14s"
  ];

  boot.kernelModules = [ "kvm-amd" ];

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
  };

  virtualisation.docker.extraOptions = "--bip=192.168.1.5/24";

  networking.hostName = "gorgon";

  dadada = {
    admin.enable = false;
    steam.enable = true;
    fido2 = {
      credential = "04ea2813a116f634e90f9728dbbb45f1c0f93b7811941a5a14fb75e711794df0c26552dae2262619c1da2be7562ec9dd94888c71a9326fea70dfe16214b5ea8ec01473070000";
      enablePam = true;
    };
    luks.uuid = "3d0e5b93-90ca-412a-b4e0-3e6bfa47d3f4";
    networking = {
      enableBsShare = true;
      vpnExtension = "3";
    };
    backupClient = {
      enable = true;
      bs = true;
      gs = false;
    };
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 90;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.adb.enable = true;

  services.fstrim.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    browsing = true;
    drivers = with pkgs; [
      hplip
      brlaser
      brgenml1lpr
      brgenml1cupswrapper
    ];
  };

  environment.systemPackages = [ pkgs.ghostscript ];

  hardware = {
    bluetooth.enable = true;
    pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      extraConfig = ''
        set-source-volume 1 10000
      '';
      package = pkgs.pulseaudioFull;
    };
  };

  services.avahi.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22000 # Syncthing
    ];
    allowedUDPPorts = [
      21027 # Syncthing
    ];
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  xdg.mime.enable = true;

  users.users = {
    dadada = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "adbusers" "kvm" "video" "scanner" "lp" "docker" ];
      shell = "/run/current-system/sw/bin/zsh";
    };
  };

  networking.hosts = {
    "fd42:dead:beef:0:5054:ff:fefb:7361" = [
      "media.dadada.li"
      "ifrit.dadada.li"
    ];
    "192.168.42.103" = [
      "media.dadada.li"
      "ifrit.dadada.li"
    ];
    "fd42:dead:beef::5054:ff:fe8b:58df" = [ "iot.dadada.li" ];
    "fd42:dead:beef::20d:b9ff:fe4c:c9ac" = [ "agares.dadada.li" ];
    "192.168.42.15" = [ "agares.dadada.li" "agares" ];
    "192.168.42.11" = [ "wohnzimmerpi.dadada.li" "wohnzimmerpi" ];
    "10.1.2.9" = [ "fgprinter.fginfo.tu-bs.de" ];
  };

  system.stateVersion = "20.03";
}
