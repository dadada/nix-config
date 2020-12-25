{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dadada.kitty;
in {
  options.dadada.kitty = {
    enable = mkEnableOption "Enable kitty config";
  };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        package = pkgs.source-code-pro;
        name = "Source Code Pro 8";
      };
      extraConfig = builtins.readFile ./config;
    };
  };
}
