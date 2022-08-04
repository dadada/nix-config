{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.dadada.home.direnv;
in {
  options.dadada.home.direnv = {
    enable = mkEnableOption "Enable direnv config";
  };
  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
