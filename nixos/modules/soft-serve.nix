{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.soft-serve;
  configFile = format.generate "config.yaml" cfg.settings;
  exe = getExe cfg.package;
  format = pkgs.formats.yaml { };
  user = "soft-serve";
in
{
  options = {
    services.soft-serve = {
      enable = mkEnableOption "Enable soft-serve service";

      package = mkPackageOption pkgs "soft-serve" { };

      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/soft-serve";
        description = lib.mdDoc ''
          The absolute path to the data directory.

          See <https://github.com/charmbracelet/soft-serve>.
        '';
      };

      user = mkOption {
        type = types.str;
        default = user;
        description = lib.mdDoc "User account under which soft-serve runs.";
      };

      group = mkOption {
        type = types.str;
        default = user;
        description = lib.mdDoc "Group account under which soft-serve runs.";
      };

      settings = mkOption {
        type = format.type;
        default = { };
        description = lib.mdDoc ''
          The contents of the configuration file.

          See <https://github.com/charmbracelet/soft-serve>.
        '';
        example = literalExpression ''
          {
            # Soft Serve Server configurations

            # The name of the server.
            # This is the name that will be displayed in the UI.
            name = "Soft Serve";

            # Log format to use. Valid values are "json", "logfmt", and "text".
            log_format = "text";

            # The SSH server configuration.
            ssh = {
              # The address on which the SSH server will listen.
              listen_addr = ":23231";

              # The public URL of the SSH server.
              # This is the address that will be used to clone repositories.
              public_url = "ssh://localhost:23231";

              # The path to the SSH server's private key.
              key_path = "ssh/soft_serve_host";

              # The path to the SSH server's client private key.
              # This key will be used to authenticate the server to make git requests to
              # ssh remotes.
              client_key_path = "ssh/soft_serve_client";

              # The maximum number of seconds a connection can take.
              # A value of 0 means no timeout.
              max_timeout = 0;

              # The number of seconds a connection can be idle before it is closed.
              idle_timeout = 120;
            };
            # The Git daemon configuration.
            git = {
              # The address on which the Git daemon will listen.
              listen_addr = ":9418";

              # The maximum number of seconds a connection can take.
              # A value of 0 means no timeout.
              max_timeout = 0;

              # The number of seconds a connection can be idle before it is closed.
              idle_timeout = 3;

              # The maximum number of concurrent connections.
              max_connections = 32;
            };

            # The HTTP server configuration.
            http = {
              # The address on which the HTTP server will listen.
              listen_addr = ":23232";

              # The path to the TLS private key.
              tls_key_path = "";

              # The path to the TLS certificate.
              tls_cert_path = "";

              # The public URL of the HTTP server.
              # This is the address that will be used to clone repositories.
              # Make sure to use https:// if you are using TLS.
              public_url = "http://localhost:23232";

            };

            # The stats server configuration.
            stats = {
              # The address on which the stats server will listen.
              listen_addr = ":23233";
            };
            # Additional admin keys.
            initial_admin_keys = [
              "ssh-rsa AAAAB3NzaC1yc2..."
            ];
          };
        '';
      };
    };
  };

  config = let stateDir = cfg.stateDir; in mkIf cfg.enable {
    users.users = mkIf (cfg.user == "soft-serve") {
      soft-serve = {
        description = "soft-serve service";
        home = cfg.stateDir;
        useDefaultShell = true;
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "soft-serve") {
      soft-serve = { };
    };

    systemd.tmpfiles.rules = [
      "d '${stateDir}' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.soft-serve = {
      description = "Soft Serve git server 🍦";
      documentation = [ "https://github.com/charmbracelet/soft-serve" ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        SOFT_SERVE_DATA_PATH = stateDir;
      };

      preStart = ''
        # Link the settings file into the data directory.
        ln -fs ${configFile} ${stateDir}/config.yaml
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = "1";
        ExecStart = "${exe} serve";
        WorkingDirectory = stateDir;
        RuntimeDirectory = "soft-serve";
        RuntimeDirectoryMode = "0750";
        ProcSubset = "pid";
        ProtectProc = "invisible";
        ReadWritePaths = [ stateDir ];
        UMask = "0027";
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@cpu-emulation @debug @keyring @module @mount @obsolete @privileged @raw-io @reboot @setuid @swap"
        ];
      };
    };
  };

  meta.maintainers = [ maintainers.dadada ];
}
