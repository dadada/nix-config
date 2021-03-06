{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dadada.networking;
in
{
  options = {
    dadada.networking = {
      useLocalResolver = mkEnableOption "Enable local caching name server";
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
    networking.resolvconf.useLocalResolver = mkIf cfg.useLocalResolver true;
    services.unbound = mkIf cfg.useLocalResolver {
      enable = true;
      settings = {
        server.interface = [
          "127.0.0.1"
          "::1"
        ];
        tls-upstream = "yes";
        tls-cert-bundle = "/etc/ssl/certs/ca-bundle.crt";
        forward-zone = [
          {
            name = ".";
            forward-tls-upstream = "yes";
            forward-addr = [
              "2606:4700:4700::1001@853#cloudflare-dns.com"
              "2606:4700:4700::1111@853#cloudflare-dns.com"
              "1.1.1.1@853#cloudflare-dns.com"
              "1.0.0.1@853#cloudflare-dns.com"
            ];
          }
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
