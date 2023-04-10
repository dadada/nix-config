{ config
, pkgs
, lib
, secretsPath
, ...
}:
let
  signHook =
    pkgs.writeShellScript "/etc/nix/sign-cache.sh"
      ''
        set -eu
        set -f # disable globbing
        export IFS=' '

        echo "Signing paths" $OUT_PATHS
        nix store sign --key-file /etc/nix/key.private $OUT_PATHS
      '';

  xilinxJtag = pkgs.writeTextFile {
    name = "xilinx-jtag";
    text = ''
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", TAG+="uaccess"
    '';
    destination = "/etc/udev/rules.d/61-xilinx-jtag.rules";
  };
  saleaeLogic = pkgs.writeTextFile {
    name = "saleae-logic";
    text = ''
      # Saleae Logic analyzer (USB Based)
      ATTRS{idVendor}=="21a9", ATTRS{idProduct}=="1006", TAG+="uaccess"
    '';
    destination = "/etc/udev/rules.d/61-saleae-logic.rules";
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    # Prevent garbage collection for nix shell and direnv
    keep-outputs = true
    keep-derivations = true
  '';

  boot.kernelModules = [ "kvm-amd" ];

  networking.hostName = "gorgon";

  dadada = {
    #headphones.enable = true;
    steam.enable = true;
    kanboard.enable = true;
    #fido2 = {
    #  credential = "04ea2813a116f634e90f9728dbbb45f1c0f93b7811941a5a14fb75e711794df0c26552dae2262619c1da2be7562ec9dd94888c71a9326fea70dfe16214b5ea8ec01473070000";
    #  enablePam = true;
    #};
    luks.uuid = "3d0e5b93-90ca-412a-b4e0-3e6bfa47d3f4";
    networking = {
      enableBsShare = true;
      localResolver = {
        enable = true;
        uwu = true;
        s0 = true;
      };
      vpnExtension = "3";
    };
    sway.enable = false;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 90;
  };

  programs.adb.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  programs.wireshark.enable = true;

  services.avahi.enable = true;

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

  environment.systemPackages = with pkgs; [
    chromium
    ghostscript
    config.dadada.pkgs.recipemd
    config.dadada.pkgs.map
    cachix
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

  systemd.services.modem-manager.enable = lib.mkForce false;
  systemd.services."dbus-org.freedesktop.ModemManager1".enable = lib.mkForce false;

  services.udev.packages = [ xilinxJtag saleaeLogic ]; #noMtpUdevRules ];

  virtualisation.libvirtd.enable = true;

  users.users = {
    dadada = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "adbusers" "kvm" "video" "scanner" "lp" "docker" "dialout" "wireshark" ];
      shell = "/run/current-system/sw/bin/zsh";
    };
  };

  networking.hosts = {
    "10.1.2.9" = [ "fgprinter.fginfo.tu-bs.de" ];
    "127.0.0.2" = [ "kanboard.dadada.li" ];
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

  #networking.wg-quick.interfaces.mullvad = {
  #  address = [ "10.68.15.202/32" "fc00:bbbb:bbbb:bb01::5:fc9/128" ];
  #  privateKeyFile = "/var/lib/wireguard/mullvad";
  #  peers = [
  #    {
  #      publicKey = "Ec/wwcosVal9Kjc97ZuTTV7Dy5c0/W5iLet7jrSEm2k=";
  #      allowedIPs = [ "0.0.0.0/0" "::0/0" ];
  #      endpoint = "193.27.14.66:51820";
  #      persistentKeepalive = 25;
  #    }
  #  ];
  #  postUp = "${pkgs.iproute2}/bin/ip rule add to 193.27.14.66 lookup main";
  #};

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  system.stateVersion = "20.03";
}
