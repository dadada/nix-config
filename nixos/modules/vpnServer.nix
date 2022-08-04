{ config
, pkgs
, lib
, ...
}:
with lib; let
  cfg = config.dadada.vpnServer;
  wgPeer = { name, ... }: {
    options = {
      name = mkOption {
        internal = true;
        default = name;
      };
      id = mkOption {
        description = "VPN client id";
        default = 0;
        type = types.str;
      };
      key = mkOption {
        description = "VPN client public key";
        default = "";
        type = types.str;
      };
    };
  };
in
{
  options.dadada.vpnServer = {
    enable = mkEnableOption "Enable wireguard gateway";
    peers = mkOption {
      description = "Set of extensions and public keys of peers";
      type = with types; attrsOf (submodule wgPeer);
      default = { };
    };
  };
  config = mkIf cfg.enable {
    networking.wireguard = {
      enable = true;
      interfaces."wg0" = {
        allowedIPsAsRoutes = true;
        privateKeyFile = "/var/lib/wireguard/wg0-key";
        ips = [ "fd42:9c3b:f96d:0201::0/64" ];
        listenPort = 51234;
        peers =
          map
            (peer: {
              allowedIPs = [ "fd42:9c3b:f96d:0201::${peer.id}/128" ];
              publicKey = peer.key;
            })
            (attrValues cfg.peers);
        postSetup = ''
          wg set wg0 fwmark 51234
          ip -6 route add table 2468 fd42:9c3b:f96d::/48 dev ens3
          ip -6 route add table 2468 fd42:9c3b:f96d:201::/64 dev wg0
          ip -6 rule add fwmark 51234 table 2468
        '';
      };
    };
    boot.kernel.sysctl = {
      # Enable forwarding for VPN
      "net.ipv6.conf.wg0.forwarding" = true;
      "net.ipv6.conf.ens3.forwarding" = true;
    };
  };
}
