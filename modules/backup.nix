{ config, pkgs, lib, ... }:
with lib;
let
  backupExcludes = [
    "/backup"
    "/dev"
    "/efi"
    "/home/*/.cache"
    "/home/*/.config/Riot/Cache"
    "/home/iserv"
    "/lost+found"
    "/mnt"
    "/nix"
    "/proc"
    "/run"
    "/sys"
    "/tmp"
    "/var/cache"
    "/var/log"
    "/var/tmp"
  ];
  cfg = config.dadada.backupClient;
in
{
  options.dadada.backupClient = {
    enable = mkEnableOption "Enable backup client";
    gs = mkEnableOption "Enable backup to GS location";
    bs = mkEnableOption "Enable backup to BS location";
  };

  config = mkIf cfg.enable {

    fileSystems = mkIf cfg.gs {
      "/backup" = {
        device = "/dev/disk/by-uuid/0fdab735-cc3e-493a-b4ec-cbf6a77d48d5";
        fsType = "ext4";
        options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
      };
    };

    services.borgbackup.jobs.gs = mkIf cfg.gs {
      paths = "/";
      exclude = backupExcludes;
      repo = "/backup/${config.networking.hostName}";
      doInit = false;
      encryption = {
        mode = "repokey";
        passCommand = "cat /var/lib/borgbackup/gs/passphrase";
      };
      compression = "auto,lz4";
      prune.keep = {
        within = "1d"; # Keep all archives from the last day
        daily = 7;
        weekly = 2;
        monthly = -1; # Keep at least one archive for each month
        yearly = -1; # Keep at least one archive for each year
      };
      startAt = "monthly";
    };

    networking.hosts = mkIf cfg.bs {
      "fd42:dead:beef:0:5054:ff:fefb:7361" = [
        "media.dadada.li"
      ];
    };

    services.borgbackup.jobs.bs = mkIf cfg.bs {
      paths = "/";
      exclude = backupExcludes;
      repo = "borg@media.dadada.li:/mnt/storage/backup/${config.networking.hostName}";
      doInit = true;
      environment = {
        BORG_RSH = "ssh -i /var/lib/borgbackup/bs/id_ed25519 -o 'StrictHostKeyChecking accept-new'";
      };
      encryption = {
        mode = "repokey";
        passCommand = "cat /var/lib/borgbackup/bs/passphrase";
      };
      compression = "auto,lz4";
      startAt = "daily";
    };
  };
}
