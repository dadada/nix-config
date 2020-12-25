{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dadada.direnv;
in
{
  options.dadada.direnv = {
    enable = mkEnableOption "Enable direnv config";
  };
  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNixDirenvIntegration = true;
    };
  };
}
