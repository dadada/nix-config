{ ... }:
{
  services.unbound = {
    enable = true;
    localControlSocketPath = "/run/unbound/unbound.ctl";
    settings = {
      server = {
        access-control = [
          "127.0.0.0/8 allow"
          "127.0.0.1/32 allow_snoop"
          "192.168.100.0/24 allow"
          "192.168.101.0/24 allow"
          "192.168.102.0/24 allow"
          "192.168.103.0/24 allow"
          "192.168.1.0/24 allow"
          "172.16.128.0/24 allow"
          "::1/128 allow_snoop"
          "fd42:9c3b:f96d::/48 allow"
        ];
        interface = [
          "127.0.0.1"
          "192.168.1.1"
          "192.168.100.1"
          "192.168.101.1"
          "192.168.102.1"
          "::1"
          "fd42:9c3b:f96d:100::1"
          "fd42:9c3b:f96d:101::1"
          "fd42:9c3b:f96d:102::1"
          "fd42:9c3b:f96d:103::1"
        ];
        prefer-ip6 = true;
        prefetch = true;
        prefetch-key = true;
        serve-expired = false;
        aggressive-nsec = true;
        hide-identity = true;
        hide-version = true;
        use-caps-for-id = true;
        val-permissive-mode = true;
        local-data = [
          "\"agares.bs.dadada.li. 10800 IN A 192.168.101.1\""
          "\"ninurta.bs.dadada.li. 10800 IN A 192.168.101.184\""
          "\"agares.bs.dadada.li. 10800 IN AAAA fd42:9c3b:f96d:101::1\""
          "\"ninurta.bs.dadada.li. 10800 IN A fd42:9c3b:f96d:101:4a21:bff:fe3e:9cfe\""
        ];
        local-zone = [
          "\"168.192.in-addr.arpa.\" nodefault"
          "\"d.f.ip6.arpa.\" nodefault"
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
      ];
      stub-zone =
        let
          stubZone = name: addrs: { name = "${name}"; stub-addr = addrs; };
        in
        [
          #(stubZone "li.dadada.bs" ["192.168.128.220" "2a01:4f8:c010:a710::1"])
          #(stubZone "d.6.9.f.b.3.c.9.2.4.d.f.ip6.arpa" ["192.168.101.220" "2a01:4f8:c010:a710::1"])
          #(stubZone "168.192.in-addr.arpa" ["192.168.128.220" "2a01:4f8:c010:a710::1"])
        ];
    };
  };
}
