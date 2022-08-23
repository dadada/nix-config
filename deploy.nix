{ self, deploy-rs, ... }:
let
  domain = "dadada.li";
  system = "x86_64-linux";
  activateNixos = deploy-rs.lib."${system}".activate.nixos;
  configs = self.nixosConfigurations;
  daNode = hostname: {
    hostname = "${hostname}.${domain}";
    fastConnection = true;
    profiles = {
      system = {
        sshUser = "dadada";
        path = activateNixos configs."${hostname}";
        user = "root";
      };
    };
  };
in
{
  nodes = builtins.mapAttrs (hostname: fun: fun hostname) {
    agares = daNode;
    ifrit = daNode;
    pruflas = daNode;
    surgat = daNode;
  };
}

