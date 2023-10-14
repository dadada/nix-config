{ pkgs, lib, config, ... }:
let
  secretsPath = config.dadada.secrets.path;
in
{
  # PPPoE
  services.pppd = {
    enable = true;
    peers = {
      telekom = {
        enable = true;
        autostart = true;
        config = ''
          debug

          plugin pppoe.so enp2s0

          noauth
          hide-password
          call telekom-secret

          linkname ppp0

          persist
          maxfail 0
          holdoff 5

          noipdefault
          defaultroute

          lcp-echo-interval 15
          lcp-echo-failure 3
        '';
      };
    };
  };

  age.secrets."etc-ppp-telekom-secret" = {
    file = "${secretsPath}/etc-ppp-telekom-secret.age";
    owner = "root";
    mode = "700";
    path = "/etc/ppp/peers/telekom-secret";
  };

  age.secrets."etc-ppp-pap-secrets" = {
    # format: client server passphrase
    file = "${secretsPath}/etc-ppp-chap-secrets.age";
    owner = "root";
    mode = "700";
    path = "/etc/ppp/pap-secrets";
  };

  # Hook for QoS via Intermediate Functional Block
  environment.etc."ppp/ip-up" = {
    mode = "755";
    text = with lib; ''
      #!/usr/bin/env sh
      ${getBin pkgs.iproute2}/bin/tc qdisc del dev $1 ingress
      ${getBin pkgs.iproute2}/bin/tc qdisc add dev $1 handle ffff: ingress
      ${getBin pkgs.iproute2}/bin/tc filter add dev $1 parent ffff: matchall action mirred egress redirect dev ifb4ppp0
    '';
  };
}
