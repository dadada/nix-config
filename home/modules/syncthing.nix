{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.dadada.home.syncthing;
in {
  options.dadada.home.syncthing = {
    enable = mkEnableOption "Enable Syncthing config";
  };
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray = false;
    };
  };
}
