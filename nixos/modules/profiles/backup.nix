{ config, ... }:
let
  secretsPath = config.dadada.secrets.path;
in
{
  dadada.backupClient.bs = {
    enable = true;
    passphrasePath = config.age.secrets."${config.networking.hostName}-backup-passphrase.path";
    sshIdentityFile = config.age.secrets."${config.networking.hostName}-backup-ssh-key.path";
  };

  age.secrets."${config.networking.hostName}-backup-passphrase".file = "${toString secretsPath}/${config.networking.hostName}-backup-passphrase.age";
  age.secrets."${config.networking.hostName}-backup-ssh-key".file = "${toString secretsPath}/${config.networking.hostName}-backup-ssh-key.age";
}
