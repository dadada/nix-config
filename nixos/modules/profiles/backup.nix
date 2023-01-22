{ config, ... }:
let
  secretsPath = config.dadada.secrets.path;
in
{
  dadada.backupClient.bs = {
    enable = true;
    passphrasePath = config.age.secrets."${config.networking.hostName}-backup-passphrase".path;
    sshIdentityFile = config.age.secrets."${config.networking.hostName}-backup-ssh-key".path;
  };

  dadada.backupClient.gs = {
    enable = true;
    passphrasePath = config.age.secrets."${config.networking.hostName}-backup-passphrase-gs".path;
  };

  age.secrets."${config.networking.hostName}-backup-passphrase".file = "${secretsPath}/${config.networking.hostName}-backup-passphrase.age";
  age.secrets."${config.networking.hostName}-backup-passphrase-gs".file = "${secretsPath}/${config.networking.hostName}-backup-passphrase-gs.age";
  age.secrets."${config.networking.hostName}-backup-ssh-key".file = "${secretsPath}/${config.networking.hostName}-backup-ssh-key.age";
}
