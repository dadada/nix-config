{ config, lib, ... }:
with lib;
let
  cfg = config.dadada.git;
in
{
  options.dadada.git = {
    enable = mkEnableOption "Enable git config";
  };
  config = mkIf cfg.enable {
    programs.git.enable = true;
  };
}
