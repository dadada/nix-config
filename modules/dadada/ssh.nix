{ config, lib, ... }:
with lib;
let
  cfg = config.dadada.ssh;
in {
  options.dadada.ssh = {
    enable = mkEnableOption "Enable SSH config";
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
    };
  };
}
