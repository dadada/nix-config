{ config, lib, ... }:
with lib;
let
  cfg = config.dadada.fileShare;
  sharePath = "/mnt/storage/share";
  ipv6 = "fd42:dead:beef::/48";
  ipv4 = "192.168.42.0/24";
  allow = "192.168.42. fd42:dead:beef::";
in
{
  options.dadada.fileShare = {
    enable = mkEnableOption "Enable file share server";
  };
  config = mkIf cfg.enable {
    services.samba = {
      enable = true;
      securityType = "user";
      extraConfig = ''
        workgroup = WORKGROUP
        server string = media
        netbios name = media
        security = user
        #use sendfile = yes
        #max protocol = smb2
        min protocol = SMB3
        hosts allow = ${allow} localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
      '';
      shares = {
        public = {
          path = sharePath;
          browseable = "yes";
          "read only" = "yes";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "username";
          "force group" = "groupname";
        };
      };
    };
    services.nfs = {
      server.enable = true;
      server.exports = ''
        ${sharePath} ${ipv6}(rw,all_squash,insecure,subtree_check) ${ipv4}(rw,all_squash,insecure,subtree_check) # map to user/group - in this case nobody
      '';
    };
  };
}
