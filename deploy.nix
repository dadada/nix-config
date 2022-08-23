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
  nodes.ifrit = daNode "ifrit";
  nodes.pruflas = daNode "pruflas";
}

