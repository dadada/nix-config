{ config, lib, ... }:
with lib;
let
  cfg = config.dadada.home.gpg;
in
{
  options.dadada.home.gpg = {
    enable = mkEnableOption "Enable GnuPG config";
  };
  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      settings = {
        fixed-list-mode = true;
        keyid-format = "0xlong";
        verify-options = "show-uid-validity";
        list-options = "show-uid-validity";
        cert-digest-algo = "SHA256";
        use-agent = true;
        keyserver = "hkps://keys.openpgp.org";
      };
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = false;
      pinentryFlavor = "gnome3";
    };

    programs.git.extraConfig = {
      commit = { gpgSign = true; };
    };
  };
}
