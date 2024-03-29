let
  dadada = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+bBJptw2H35vMPV7Mfj9oaepR7cHCQH8ZsvL8qnj+r dadada (nix-config-secrets) <dadada@dadada.li>";
  systems = {
    agares = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcbuLtU9/VhFy5VAp/ZI0T+gr7kExG73hmjjvno10gP root@nixos";
    gorgon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCcwG8BkqjZJ1bPdFbLYfXeBgaI10+gyVs1r1aNJ49H root@gorgon";
    ifrit = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYO4L5EvKRtVUB6YHtHN7R980fwH9kKVt0V3kj6rORS root@nixos";
    ninurta = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8TDCzjVVO7A4k6rp+srMj0HHc5gmUOlskTBOvhMkEc root@nixos";
    pruflas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBqZHu5ygTODgrNzcU9C2O+b8yCfVsnztV83qxXV4aA8 root@pruflas";
    surgat = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOOJ9UgAle5sX0pAawfRztckVwaQm2U8o0Bawv7cZfXE root@surgat";
  };
  backupSecrets = hostName: {
    "${hostName}-backup-passphrase.age".publicKeys = [ systems.${hostName} dadada ];
    "${hostName}-backup-ssh-key.age".publicKeys = [ systems.${hostName} dadada ];
  };
in
{
  "pruflas-wg0-key.age".publicKeys = [ systems.ninurta dadada ];
  "pruflas-wg0-preshared-key.age".publicKeys = [ systems.ninurta dadada ];
  "pruflas-wg-hydra-key.age".publicKeys = [ systems.ninurta dadada ];
  "hydra-github-authorization.age".publicKeys = [ systems.ninurta dadada ];
  "miniflux-admin-credentials.age".publicKeys = [ systems.surgat dadada ];
  "gorgon-backup-passphrase-gs.age".publicKeys = [ systems.gorgon dadada ];
  "paperless.age".publicKeys = [ systems.gorgon dadada ];
  "surgat-ssh_host_ed25519_key.age".publicKeys = [ systems.surgat dadada ];
  "ninurta-initrd-ssh-key.age".publicKeys = [ systems.ninurta dadada ];
  "ddns-credentials.age".publicKeys = [ systems.agares systems.ninurta dadada ];
  "etc-ppp-chap-secrets.age".publicKeys = [ systems.agares dadada ];
  "etc-ppp-telekom-secret.age".publicKeys = [ systems.agares dadada ];
  "wg-privkey-vpn-dadada-li.age".publicKeys = [ systems.agares dadada ];
  "agares-wg0-key.age".publicKeys = [ systems.agares dadada ];
} //
backupSecrets "ninurta" //
backupSecrets "gorgon" //
backupSecrets "ifrit" //
backupSecrets "pruflas" //
backupSecrets "surgat" //
backupSecrets "agares"
