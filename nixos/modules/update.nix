{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dadada.autoUpgrade;
in
{

  options.dadada.autoUpgrade = {
    enable = mkEnableOption "Enable automatic upgrades";
  };

  config = mkIf cfg.enable {
    nix = {
      autoOptimiseStore = false;
      useSandbox = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    system.autoUpgrade = {
      enable = true;
      dates = "daily";
    };
  };
}
