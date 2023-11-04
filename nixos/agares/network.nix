{ config, lib, ... }:
let
  mergeAttrsList = lib.attrsets.mergeAttrsList;
  map = builtins.map;
  ulaPrefix = "fd42:9c3b:f96d"; # fd42:9c3b:f96d::/48
  ipv4Prefix = "192.168"; # 192.168.96.0/19
  domain = "bs.dadada.li";
in
{
  systemd.network = {
    enable = true;
    links = {
      "10-persistent" = {
        matchConfig.OriginalName = [ "enp1s0" "enp2s0" ];
        linkConfig.MACAddressPolicy = "persistent";
      };
    };
    netdevs = {
      # QoS concentrator
      "ifb4ppp0" = {
        netdevConfig = {
          Kind = "ifb";
          Name = "ifb4ppp0";
        };
      };
      "20-lan" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "lan.10";
        };
        vlanConfig = {
          Id = 10;
        };
      };
      "20-freifunk" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "ff.11";
        };
        vlanConfig = {
          Id = 11;
        };
      };
      "20-srv" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "srv.13";
        };
        vlanConfig = {
          Id = 13;
        };
      };
      "20-roadw" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "roadw";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets."wg-privkey-vpn-dadada-li".path;
          ListenPort = 51234;
        };
        wireguardPeers = [{
          wireguardPeerConfig =
            let
              peerAddresses = i: [
                "${ipv4Prefix}.120.${i}/32"
                "${ulaPrefix}:120::${i}/128"
              ];
            in
            {
              PublicKey = "0eWP1hzkyoXlrjPSOq+6Y1u8tnFH+SejBJs8f8lf+iU=";
              AllowedIPs = peerAddresses "3";
            };
        }];
      };
    };
    networks =
      let
        subnet = name: subnetId: {
          matchConfig.Name = name;
          addresses = [
            { addressConfig.Address = "${ipv4Prefix}.${subnetId}.1/24"; }
            { addressConfig.Address = "${ulaPrefix}:${subnetId}::1/64"; }
          ];
          dhcpPrefixDelegationConfig = {
            SubnetId = "auto";
          };
          ipv6Prefixes = [
            {
              ipv6PrefixConfig.Prefix = "${ulaPrefix}:${subnetId}::/64";
            }
          ];
          dhcpServerConfig = {
            DNS = "${ipv4Prefix}.${subnetId}.1";
            NTP = "${ipv4Prefix}.${subnetId}.1";
            EmitDNS = true;
            EmitNTP = true;
            EmitRouter = true;
            PoolOffset = 100;
            PoolSize = 100;
            SendOption = "12:string:${domain}";
          };
          linkConfig = {
            RequiredForOnline = "no";
          };
          networkConfig = {
            Domains = domain;
            EmitLLDP = "yes";
            IPv6SendRA = true;
            IPv6AcceptRA = false;
            DHCPPrefixDelegation = true;
            DHCPServer = true;
          };
          extraConfig = ''
            [CAKE]
            OverheadBytes = 38
            Bandwidth = 1G
          '';
        };
      in
      {
        "10-mgmt" = subnet "enp1s0" "100" // {
          networkConfig.VLAN = [ "lan.10" "ff.11" "srv.13" ];
          dhcpServerStaticLeases = [
            {
              # legion
              dhcpServerStaticLeaseConfig = {
                Address = "192.168.100.107";
                MACAddress = "80:CC:9C:95:4A:60";
              };
            }
          ];
        };
        "30-lan" = subnet "lan.10" "101" // {
          dhcpServerStaticLeases = [
            {
              # ninurta
              dhcpServerStaticLeaseConfig = {
                Address = "192.168.101.184";
                MACAddress = "48:21:0B:3E:9C:FE";
              };
            }
            {
              # crocell
              dhcpServerStaticLeaseConfig = {
                Address = "192.168.101.122";
                MACAddress = "9C:C9:EB:4F:3F:0E";
              };
            }
            {
              # gorgon
              dhcpServerStaticLeaseConfig = {
                Address = "192.168.101.205";
                MACAddress = "8C:C6:81:6A:39:2F";
              };
            }
          ];
        };

        "30-ff" = subnet "ff.11" "102";

        "30-srv" = subnet "srv.13" "103";

        "30-ifb4ppp0" = {
          name = "ifb4ppp0";
          extraConfig = ''
            [CAKE]
            OverheadBytes = 65
            Bandwidth = 95M
            FlowIsolationMode = triple
          '';
        };

        "30-ppp0" = {
          name = "ppp*";
          linkConfig = {
            RequiredForOnline = "routable";
          };
          networkConfig = {
            KeepConfiguration = "static";
            DefaultRouteOnDevice = true;
            LinkLocalAddressing = "ipv6";
            DHCP = "ipv6";
          };
          extraConfig = ''
            [CAKE]
            OverheadBytes = 65
            Bandwidth = 36M
            FlowIsolationMode = triple
            [DHCPv6]
            PrefixDelegationHint= ::/56
            UseAddress = false
            UseDelegatedPrefix = true
            WithoutRA = solicit
            [DHCPPrefixDelegation]
            UplinkInterface=:self
          '';
          ipv6SendRAConfig = {
            # Let networkd know that we would very much like to use DHCPv6
            # to obtain the "managed" information. Not sure why they can't
            # just take that from the upstream RAs.
            Managed = true;
          };
        };
        # Talk to modem for management
        "enp2s0" = {
          name = "enp2s0";
          linkConfig = {
            RequiredForOnline = "no";
          };
          networkConfig = {
            Address = "192.168.1.254/24";
            EmitLLDP = "yes";
          };
        };
        "10-roadw" = {
          matchConfig.Name = "roadw";
          address = [
            "${ipv4Prefix}.120.1/32"
            "${ulaPrefix}:120::1/128"
          ];
          DHCP = "no";
          networkConfig.IPv6AcceptRA = false;
          linkConfig.RequiredForOnline = "no";
          routes = [
            {
              routeConfig = { Destination = "${ipv4Prefix}.120.1/24"; };
            }
            {
              routeConfig = { Destination = "${ulaPrefix}::120:1/64"; };
            }
          ];
        };
      };
  };

  age.secrets."wg-privkey-vpn-dadada-li" = {
    file = "${config.dadada.secrets.path}/wg-privkey-vpn-dadada-li.age";
    owner = "systemd-network";
  };

  boot.kernel.sysctl = {
    # Enable forwarding for interface
    "net.ipv4.conf.all.forwarding" = "1";
    "net.ipv6.conf.all.forwarding" = "1";
    "net.ipv6.conf.all.accept_ra" = "0";
    "net.ipv6.conf.all.autoconf" = "0";
    # Set via systemd-networkd
    #"net.ipv6.conf.${intf}.use_tempaddr" = "0";
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
}
