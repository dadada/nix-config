{ config, pkgs, lib, ... }:
let
  signHook = pkgs.writeShellScript "/etc/nix/sign-cache.sh"
    ''
      set -eu
      set -f # disable globbing
      export IFS=' '

      echo "Signing paths" $OUT_PATHS
      nix store sign --key-file /etc/nix/key.private $OUT_PATHS
    '';
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    post-build-hook = ${signHook}
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = [ "kvm-amd" ];

  networking.hostName = "gorgon";

  dadada = {
    autoUpgrade.enable = false;
    headphones.enable = true;
    steam.enable = true;
    #fido2 = {
    #  credential = "04ea2813a116f634e90f9728dbbb45f1c0f93b7811941a5a14fb75e711794df0c26552dae2262619c1da2be7562ec9dd94888c71a9326fea70dfe16214b5ea8ec01473070000";
    #  enablePam = true;
    #};
    luks.uuid = "3d0e5b93-90ca-412a-b4e0-3e6bfa47d3f4";
    networking = {
      enableBsShare = true;
      localResolver = {
        enable= true;
        uwu= true;
        s0= true;
      };
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

  programs.adb.enable = true;

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

  services.miniflux = {
    enable = true;
    config = {
      CLEANUP_FREQUENCY = "48";
      LISTEN_ADDR = "localhost:8080";
    };
    adminCredentialsFile = "/var/lib/miniflux/admin-credentials";
  };

  environment.systemPackages = with pkgs; [
    chromium
    ghostscript
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22000 # Syncthing
    ];
    allowedUDPPorts = [
      21027 # Syncthing
    ];
  };

  virtualisation.libvirtd.enable = true;

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

  networking.wireguard.interfaces.uwupn = {
    ips = [ "10.11.0.24/32" "fc00:1337:dead:beef::10.11.0.24/128" ];
    privateKeyFile = "/var/lib/wireguard/uwu";
    peers = [
      {
        publicKey = "tuoiOWqgHz/lrgTcLjX+xIhvxh9jDH6gmDw2ZMvX5T8=";
        allowedIPs = [ "10.11.0.0/22" "fc00:1337:dead:beef::10.11.0.0/118" "192.168.178.0/23" ];
        endpoint = "53c70r.de:51820";
        persistentKeepalive = 25;
      }
    ];
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  system.stateVersion = "20.03";
}
