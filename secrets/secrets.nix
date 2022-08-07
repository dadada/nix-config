let
  dadada = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+bBJptw2H35vMPV7Mfj9oaepR7cHCQH8ZsvL8qnj+r dadada (nix-config-secrets) <dadada@dadada.li>";
  systems = {
    agares = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcbuLtU9/VhFy5VAp/ZI0T+gr7kExG73hmjjvno10gP root@nixos";
    gorgon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCcwG8BkqjZJ1bPdFbLYfXeBgaI10+gyVs1r1aNJ49H root@gorgon";
    ifrit = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYO4L5EvKRtVUB6YHtHN7R980fwH9kKVt0V3kj6rORS root@nixos";
    pruflas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKnYOgzxZ4DAeFL88MhIVtNmMEHMQhi/pNJDbwFWOJW root@pruflas";
    surgat = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOOJ9UgAle5sX0pAawfRztckVwaQm2U8o0Bawv7cZfXE root@surgat";
  };
  backupSecrets = hostName: {
    "${hostName}-backup-passphrase.age".publicKeys = [ systems.${hostName} dadada ];
    "${hostName}-backup-ssh-key.age".publicKeys = [ systems.${hostName} dadada ];
  };
in
{ } //
backupSecrets "gorgon" //
backupSecrets "ifrit" //
backupSecrets "pruflas" //
backupSecrets "surgat" //
backupSecrets "agares"
