{ config, lib, ... }:
let
  secretsPath = config.dadada.secrets.path;
  initrdHostKey = "${config.networking.hostName}-ssh_host_ed25519_key";
in
{
  boot.initrd.availableKernelModules = [ "virtio-pci" ];
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 43235;
      hostKeys = [
        age.secrets."${initrdHostKey}"
      ];
      authorizedKeys = with lib;
        concatLists (mapAttrsToList
          (name: user:
            if elem "wheel" user.extraGroups then
              user.openssh.authorizedKeys.keys
            else
              [ ])
          config.users.users);
    };
    postCommands = ''
      echo 'cryptsetup-askpass' >> /root/.profile
    '';
  };

  age.secrets."${initrdHostKey}" = {
    file = "${secretsPath}/${initrdHostKey}";
    mode = "600";
  };
}
