{ config, lib, ... }:
with lib;
let
  cfg = config.dadada.home.git;
in
{
  options.dadada.home.git = {
    enable = mkEnableOption "Enable git config";
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      extraConfig = {
        status = {
          short = true;
          branch = 1;
        };
        commit = {
          verbose = 1;
        };
        log = {
          date = "iso8601-local";
        };
      };
    };
  };
}
