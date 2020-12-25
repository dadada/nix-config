{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dadada.autoUpgrade;
in {
  options = {
    dadada.autoUpgrade = {
      enable = mkEnableOption "Enable automatic upgrades";
    };
  };

  config = mkIf cfg.enable {
    services.fwupd.enable = true;

    nix = {
      autoOptimiseStore = true;
      useSandbox = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };

    system.autoUpgrade = {
      enable = true;
      dates = "daily";
    };
  };
}
