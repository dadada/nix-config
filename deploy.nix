{ self, deploy-rs, ... }:
let
  domain = "dadada.li";
  configs = self.nixosConfigurations;
  daNode = hostname:
    let
      config = self.nixosConfigurations."${hostname}";
      system = config.pkgs.system;
      activateNixos = deploy-rs.lib."${system}".activate.nixos;
    in
    {
      hostname = "${hostname}.${domain}";
      fastConnection = true;
      profiles = {
        system = {
          sshUser = "dadada";
          path = activateNixos config;
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

