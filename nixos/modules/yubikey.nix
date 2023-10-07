{ config
, pkgs
, lib
, ...
}:
with lib; let
  yubikey = config.dadada.yubikey;
in
{
  options = {
    dadada.yubikey = {
      enable = mkEnableOption "Enable Yubikey";
      fido2Credentials = mkOption {
        type = with types; listOf str;
        description = "FIDO2 credential strings";
        default = [ ];
      };
      luksUuid = mkOption {
        type = with types; nullOr str;
        description = "Device UUID";
        default = null;
      };
    };
  };

  config = mkIf yubikey.enable {
    boot.initrd.luks = {
      fido2Support = true;
      devices = mkIf (yubikey.luksUuid != null) {
        root = {
          device = "/dev/disk/by-uuid/${yubikey.luksUuid}";
          preLVM = true;
          allowDiscards = true;
          fido2 = mkIf (yubikey.fido2Credentials != [ ]) {
            credentials = yubikey.fido2Credentials;
            passwordLess = true;
          };
        };
      };
    };

    security.pam = {
      # Keys must be placed in $XDG_CONFIG_HOME/Yubico/u2f_keys
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
      u2f = {
        control = "sufficient";
        cue = true;
      };
    };

    services.pcscd.enable = true;

    services.udev.packages = [ pkgs.yubikey-personalization ];

    environment.systemPackages = with pkgs; [
      fido2luks
      linuxPackages.acpi_call
      pam_u2f
      pamtester
      yubikey-manager
      yubikey-manager-qt
    ];
  };
}
