{ config
, pkgs
, lib
, ...
}:
let
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
  keychron = pkgs.writeTextFile {
    name = "keychron";
    text = ''
      # Saleae Logic analyzer (USB Based)
      ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0280", TAG+="uaccess"
    '';
    destination = "/etc/udev/rules.d/61-keychron.rules";
  };
in
{
  imports = [
    ../modules/profiles/laptop.nix
    ./hardware-configuration.nix
  ];

  dadada.backupClient.backup2 = {
    enable = true;
    passphrasePath = config.age.secrets."${config.networking.hostName}-backup-passphrase".path;
    sshIdentityFile = config.age.secrets."${config.networking.hostName}-backup-ssh-key".path;
    repo = "u355513-sub1@u355513-sub1.your-storagebox.de:/home/backup";
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    # Prevent garbage collection for nix shell and direnv
    keep-outputs = true
    keep-derivations = true
  '';

  boot = {
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "resume=/dev/disk/by-label/swap" ];
    initrd = {
      systemd.enable = true;
      luks.devices = {
        root = {
          device = "/dev/disk/by-uuid/3d0e5b93-90ca-412a-b4e0-3e6bfa47d3f4";
          preLVM = true;
          allowDiscards = true;
          crypttabExtraOpts = [ "fido2-device=auto" ];
        };
      };
    };
    kernel.sysctl = {
      "vm.swappiness" = 90;
    };
  };

  networking.hostName = "gorgon";

  dadada = {
    steam.enable = true;
    yubikey.enable = true;
  };

  programs.adb.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  programs.wireshark.enable = true;

  services.avahi.enable = true;

  services.tor = {
    enable = true;
    client.enable = true;
  };

  services.paperless = {
    enable = true;
    passwordFile = config.age.secrets.paperless.path;
  };

  systemd.tmpfiles.rules = let cfg = config.services.paperless; in [
    (if cfg.consumptionDirIsPublic then
      "d '${cfg.consumptionDir}' 777 - - - -"
    else
      "d '${cfg.consumptionDir}' 770 ${cfg.user} ${config.users.users.${cfg.user}.group} - -"
    )
  ];

  age.secrets.paperless = {
    file = "${config.dadada.secrets.path}/paperless.age";
    mode = "700";
    owner = "paperless";
  };

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

  services.udev.packages = [ xilinxJtag saleaeLogic keychron ]; #noMtpUdevRules ];

  virtualisation.libvirtd.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  users.users = {
    dadada = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "adbusers" "kvm" "video" "scanner" "lp" "docker" "dialout" "wireshark" "paperless" ];
      shell = "/run/current-system/sw/bin/zsh";
    };
  };

  networking.hosts = {
    "127.0.0.2" = [ "kanboard.dadada.li" ];
  };

  networking.wireguard.interfaces.uwupn = {
    ips = [ "10.11.0.24/32" "fc00:1337:dead:beef::10.11.0.24/128" ];
    privateKeyFile = "/var/lib/wireguard/uwu";

    postSetup = ''
      ${pkgs.systemd}/bin/resolvectl domain uwupn ~uwu
      ${pkgs.systemd}/bin/resolvectl dns uwupn 10.11.0.1
      ${pkgs.systemd}/bin/resolvectl dnssec uwupn false
    '';
    peers = [
      {
        publicKey = "tuoiOWqgHz/lrgTcLjX+xIhvxh9jDH6gmDw2ZMvX5T8=";
        allowedIPs = [ "10.11.0.0/22" "fc00:1337:dead:beef::10.11.0.0/118" ];
        endpoint = "53c70r.de:51820";
        persistentKeepalive = 25;
      }
    ];
  };

  # https://lists.zx2c4.com/pipermail/wireguard/2017-November/002028.html
  systemd.timers.wg-reresolve-dns = {
    wantedBy = [ "timers.target" ];
    partOf = [ "wg-reresolve-dns.service" ];
    timerConfig.OnCalendar = "hourly";
  };

  systemd.services.wg-reresolve-dns =
    let
      vpnPubKey = "x/y6I59buVzv9Lfzl+b17mGWbzxU+3Ke9mQNa1DLsDI=";
    in
    {
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.wireguard-tools}/bin/wg set dadada peer ${vpnPubKey} endpoint vpn.dadada.li:51234 persistent-keepalive 25 allowed-ips fd42:9c3b:f96d::/48
      '';
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

  system.stateVersion = "22.11";
}
