{ config, ... }:
{
  services.gnome-keyring = {
    enable = false;
    components = [ "pkcs11" "secrets" ];
  };
}
