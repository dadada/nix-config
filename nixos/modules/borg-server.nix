{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.dadada.borgServer;
in
{
  options = {
    dadada.borgServer = {
      enable = mkEnableOption "Enable Borg backup server";
      path = mkOption {
        type = types.path;
        default = "/var/lib/backup";
        example = "/mnt/storage/backup";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.borg.home = cfg.path;
    services.borgbackup.repos = {
      "metis" = {
        allowSubRepos = false;
        authorizedKeysAppendOnly = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDnc1gCi8lbhlLmPKvaExtCxVaAni8RrOuHUQO6wTbzR root@metis" ];
        path = "${cfg.path}/metis";
        quota = "1T";
      };
      "gorgon" = {
        allowSubRepos = false;
        authorizedKeysAppendOnly = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP6p9b2D7y2W+9BGee2yk2xsCRewNNaE6oS3CqlW61ti root@gorgon" ];
        path = "${cfg.path}/gorgon";
        quota = "1T";
      };
      "surgat" = {
        allowSubRepos = false;
        authorizedKeysAppendOnly = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGhatanrNG+M6jAkU7Yi44mJmTreJkqyZ6Z+qiEgV7O root@surgat" ];
        path = "${cfg.path}/surgat";
        quota = "50G";
      };
      "pruflas" = {
        allowSubRepos = false;
        authorizedKeysAppendOnly = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBk7f9DSnXCOIUsxFsjCKG23vHShV4TSzzPJunPOwa1I root@pruflas" ];
        path = "${cfg.path}/pruflas";
        quota = "50G";
      };
      "wohnzimmerpi" = {
        allowSubRepos = false;
        authorizedKeysAppendOnly = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK6uZ8mPQJWOL984gZKKPyxp7VLcxk42TpTh5iPP6N6k root@wohnzimmerpi" ];
        path = "${cfg.path}/wohnzimmerpi";
        quota = "50G";
      };
      "fginfo" = {
        allowSubRepos = false;
        authorizedKeysAppendOnly = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxsyJeZVlVix0FPE8S/Gx0DVutS1ZNESVdYvHBwo36wGlYpSsQoSy/2HSwbpxs88MOGw1QNboxvvpBxCWxZ5HyjxuO5SwYgtmpjPXvmqfVqNXXnLChhSnKgk9b+HesQJCbHyrF9ZAJXEFCOGhOL3YTgd6lTX3lQUXgh/LEDlrPrigUMDNPecPWxpPskP6Vvpe9u+duhL+ihyxXaV+CoPk8nkWrov5jCGPiM48pugbwAfqARyZDgFpmWwL7Xg2UKgVZ1ttHZCWwH+htgioVZMYpdkQW1aq6LLGwN34Hj2VKXzmJN5frh6vQoZr2AFGHNKyJwAMpqnoY//QwuREpZTrh root@fginfo.ibr.cs.tu-bs.de"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9N+E5fXHBL2juml+zeq/0auvqeQ5D+ljUE+EOY8cQ2 flareflo@flareflo-desktop" # restore from backup
        ];
        path = "${cfg.path}/fginfo";
        quota = "50G";
      };
      "fginfo-git" = {
        allowSubRepos = false;
        authorizedKeysAppendOnly = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmI6cUv3j0T9ofFB286sDwXwwczqi41cp4MZyGH3VWQnqBPNjICqAdY3CLhgvGBCxSe6ZgKQ+5YLsGSSlU1uhrJXW2UiVKuIPd0kjMF/9e8hmNoTTh0pdk9THfz9LLAdI1vPin1EeVReuDXlZkCI7DFYuTO9yiyZ1uLZUfT1KBRoqiqyypZhut7zT3UaDs2L+Y5hho6WiTdm7INuz6HEB7qYXzrmx93hlcuLZA7fDfyMO9F4APZFUqefcUIEyDI2b+Q/8Q2/rliT2PoC69XLVlj7HyVhfgKsOnopwBDNF3rRcJ6zz4WICPM18i4ZCmfoDTL/cFr5c41Lan1X7wS5wR root@fginfo-git"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9N+E5fXHBL2juml+zeq/0auvqeQ5D+ljUE+EOY8cQ2 flareflo@flareflo-desktop" # restore from backup
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCNSecnVGNPpX2BEvP7EkkHzx46RzJ1L3eaAyIfLYRB flareflo@Dragoncave" # restore from backup
        ];
        path = "${cfg.path}/fginfo-git";
        quota = "50G";
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.path} 0750 ${config.users.users.borg.name} ${config.users.users.borg.group} - -"
    ];
  };
}
