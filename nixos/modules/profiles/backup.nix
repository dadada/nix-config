{ config, lib, ... }:
let
  secretsPath = config.dadada.secrets.path;
in
{
  dadada.backupClient.bs = {
    enable = lib.mkDefault true;
    passphrasePath = config.age.secrets."${config.networking.hostName}-backup-passphrase".path;
    sshIdentityFile = config.age.secrets."${config.networking.hostName}-backup-ssh-key".path;
  };

  age.secrets."${config.networking.hostName}-backup-passphrase".file = "${secretsPath}/${config.networking.hostName}-backup-passphrase.age";
  age.secrets."${config.networking.hostName}-backup-ssh-key".file = "${secretsPath}/${config.networking.hostName}-backup-ssh-key.age";
}
