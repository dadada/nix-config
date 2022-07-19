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
    options = {
      dadada.backupClient = {
        gs = {
          enable = mkEnableOption "Enable backup to GS location";
          passphrasePath = mkOption {
            type = with types; nullOr str;
            description = ''
              The path to the passphrase file.
            '';
            default = "/var/lib/borgbackup/gs/passphrase";
          };
        };
        bs = {
          enable = mkEnableOption "Enable backup to BS location";
          passphrasePath = mkOption {
            type = types.str;
            description = ''
              The path to the passphrase file.
            '';
            default = "/var/lib/borgbackup/bs/passphrase";
          };
          sshIdentityFile = mkOption {
            type = types.str;
            description = ''
              Path to the SSH key that is used to transmit the backup.
            '';
            default = "/var/lib/borgbackup/bs/id_ed25519";
          };
        };
      };
    };

  config = mkIf cfg.gs.enable {
    fileSystems = mkIf cfg.gs {
      "/backup" = {
        device = "/dev/disk/by-uuid/0fdab735-cc3e-493a-b4ec-cbf6a77d48d5";
        fsType = "ext4";
        options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
      };
    };

    services.borgbackup.jobs.gs = {
      paths = "/";
      exclude = backupExcludes;
      repo = "/backup/${config.networking.hostName}";
      doInit = false;
      encryption = {
        mode = "repokey";
        passCommand = "cat ${cfg.gs.passphrasePath}";
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
    } // mkIf cfg.bs.enable {

    services.borgbackup.jobs.bs = {
      paths = "/";
      exclude = backupExcludes;
      repo = "borg@backup0.dadada.li:/mnt/storage/backup/${config.networking.hostName}";
      doInit = false;
      environment = {
        BORG_RSH = "ssh -i ${cfg.bs.sshIdentityFile} -o 'StrictHostKeyChecking accept-new' -o 'TCPKeepAlive=yes'";
      };
      encryption = {
        mode = "repokey";
        passCommand = "cat ${cfg.bs.passphrasePath}";
      };
      compression = "auto,lz4";
      startAt = "daily";
      environment = {
        BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes";
      };
    };
  };
  };
}
