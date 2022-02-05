{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dadada.networking;
in
{
  options = {
    dadada.networking = {
      localResolver = {
        enable = mkEnableOption "Enable local caching name server";
        uwu = mkEnableOption "Enable uwupn";
        s0 = mkEnableOption "Enable s0";
      };
      wanInterfaces = mkOption {
        type = with types; listOf str;
        description = "WAN network interfaces";
        default = [ ];
      };
      vpnExtension = mkOption {
        type = with types; nullOr str;
        description = "Last part of VPN address";
        default = null;
      };
      enableBsShare = mkEnableOption "Enable network share at BS location";
    };
  };

  config = {
    networking.resolvconf.useLocalResolver = mkIf cfg.localResolver.enable true;
    networking.networkmanager.dns = mkIf cfg.localResolver.enable "unbound";

    services.unbound = mkIf cfg.localResolver.enable {
      enable = true;
      settings = {
        server = {
          prefer-ip6 = true;

          prefetch = true;
          prefetch-key = true;
          serve-expired = true;

          aggressive-nsec = true;
          hide-identity = true;
          hide-version = true;

          use-caps-for-id = true;

          private-address = [
            "127.0.0.0/8"
            "10.0.0.0/8"
            "172.16.0.0/12"
            "192.168.0.0/16"
            "169.254.0.0/16"
            "fd00::/8"
            "fe80::/10"
            "::ffff:0:0/96"
          ];
          private-domain = [
            "dadada.li"
            (mkIf cfg.localResolver.uwu "uwu")
            (mkIf cfg.localResolver.s0 "s0")
          ];
          domain-insecure = [
            (mkIf cfg.localResolver.uwu "uwu")
            (mkIf cfg.localResolver.s0 "s0")
          ];
          interface = [
            "127.0.0.1"
            "::1"
          ];
        };
        forward-zone = [
          {
            name = ".";
            forward-tls-upstream = "yes";
            forward-addr = [
              "2620:fe::fe@853#dns.quad9.net"
              "2620:fe::9@853#dns.quad9.net"
              "9.9.9.9@853#dns.quad9.net"
              "149.112.112.112@853#dns.quad9.net"
            ];
          }
          (mkIf cfg.localResolver.uwu {
            name = "uwu.";
            forward-addr = [
              "fc00:1337:dead:beef::10.11.0.1"
              "10.11.0.1"
            ];
          }
          )
          (mkIf cfg.localResolver.s0 {
            name = "s0.";
            forward-addr = [
              "192.168.178.1"
            ];
          }
          )
        ];
      };
    };

    networking.useDHCP = false;

    networking.interfaces = listToAttrs (forEach cfg.wanInterfaces (i: nameValuePair i {
      useDHCP = true;
    }));

    networking.wireguard.interfaces = mkIf (cfg.vpnExtension != null) {
      bs = {
        ips = [ "fd42:dead:beef:1337::${cfg.vpnExtension}/64" ];
        listenPort = 51234;

        privateKeyFile = "/var/lib/wireguard/privkey";

        peers = [
          {
            publicKey = "lFB2DWtzp55ajV0Fk/OWdO9JlGvN9QsayYKQQHV3GEs=";
            allowedIPs = [ "fd42:dead:beef::/48" ];
            endpoint = "bs.vpn.dadada.li:51234";
            persistentKeepalive = 25;
          }
        ];
      };
    };

    # https://lists.zx2c4.com/pipermail/wireguard/2017-November/002028.html
    systemd.timers.wg-reresolve-dns = mkIf (cfg.vpnExtension != null) {
      wantedBy = [ "timers.target" ];
      partOf = [ "wg-reresolve-dns.service" ];
      timerConfig.OnCalendar = "hourly";
    };
    systemd.services.wg-reresolve-dns = mkIf (cfg.vpnExtension != null) {
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.wireguard-tools}/bin/wg set bs peer lFB2DWtzp55ajV0Fk/OWdO9JlGvN9QsayYKQQHV3GEs= endpoint bs.vpn.dadada.li:51234 persistent-keepalive 25 allowed-ips fd42:dead:beef::/48
      '';
    };

    fileSystems."/mnt/media.dadada.li" = mkIf cfg.enableBsShare {
      device = "media.dadada.li:/mnt/storage/share";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
    };

    networking.firewall = {
      enable = true;
      allowedUDPPorts = [
        51234 # Wireguard
        5353 # mDNS
      ];
    };
  };
}
