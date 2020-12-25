{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dadada.syncthing;
in {
  options.dadada.syncthing = {
    enable = mkEnableOption "Enable Syncthing config";
  };
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray = false;
    };
  };
}
