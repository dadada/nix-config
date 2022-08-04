{ config
, pkgs
, lib
, ...
}:
with lib; let
  luks = config.dadada.luks;
  fido2 = config.dadada.fido2;
in
{
  options = {
    dadada.luks = {
      uuid = mkOption {
        type = with types; nullOr str;
        description = "Device UUID";
        default = null;
      };
    };

    dadada.fido2 = {
      enablePam = mkEnableOption "Enable PAM U2F";
      credential = mkOption {
        type = with types; nullOr str;
        description = "FIDO2 credential string";
        default = null;
      };
    };
  };

  config = {
    boot.initrd.luks.devices = mkIf (luks.uuid != null) {
      root = {
        device = "/dev/disk/by-uuid/${luks.uuid}";
        preLVM = true;
        allowDiscards = true;
        fido2 = mkIf (fido2.credential != null) {
          credential = fido2.credential;
          passwordLess = true;
        };
      };
    };

    boot.initrd.luks.fido2Support = mkIf (fido2.credential != null) true;

    environment.systemPackages = mkIf (fido2.credential != null) (with pkgs; [
      linuxPackages.acpi_call
      fido2luks
      python27Packages.dbus-python
      python38Packages.solo-python
    ]);

    security.pam.u2f = mkIf fido2.enablePam {
      enable = true;
      control = "sufficient";
      cue = true;
    };
  };
}
