{ config
, pkgs
, lib
, ...
}:
with lib; let
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

      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      registry."dadada" = {
        from = {
          type = "indirect";
          id = "dadada";
        };
        to = {
          type = "github";
          owner = "dadada";
          repo = "nix-config";
        };
      };
    };
  };
}
