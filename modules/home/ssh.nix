{ config, lib, ... }:
with lib;
let
  cfg = config.dadada.home.ssh;
in {
  options.dadada.home.ssh = {
    enable = mkEnableOption "Enable SSH config";
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
    };
  };
}
