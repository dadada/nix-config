{ config, ... }:
{
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
  };

  programs.git.extraConfig = {
    commit = { gpgSign = true; };
  };
}
