{ config, lib, ... }:
with lib;
let
  cfg = config.dadada.home.keyring;
in
{
  options.dadada.home.keyring = {
    enable = mkEnableOption "Enable keyring config";
  };
  config = mkIf cfg.enable {
    services.gnome-keyring = {
      enable = false;
      components = [ "pkcs11" "secrets" ];
    };
  };
}
