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
      autoOptimiseStore = true;
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 3d";
      };
    };

    system.autoUpgrade = {
      enable = true;
      dates = "daily";
      flake = "github:dadada/nix-config#nixosConfigurations.${config.networking.hostName}.config.system.build.toplevel";
    };
  };
}
