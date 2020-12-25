{ config, lib, ... }:

with lib;
let
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
in {
  options.dadada.vpnServer = {
    enable = mkEnableOption "Enable wireguard gateway";
    peers = mkOption {
      description = "Set of extensions and public keys of peers";
      type = with types; attrsOf (submodule wgPeer);
      default = {};
    };
  };
  config = mkIf cfg.enable {
    networking.wireguard.enable = true;
    networking.wireguard.interfaces."wg0" = {
      allowedIPsAsRoutes = true;
      privateKeyFile = "/var/lib/wireguard/wg0-key";
      ips = [ "fd42:dead:beef:1337::0/64" ];
      listenPort = 51234;
      peers = map (peer: (
        {
          allowedIPs = [ "fd42:dead:beef:1337::${peer.id}/128" ];
          publicKey = peer.key;
        })) (attrValues cfg.peers);
    };
  };
}
