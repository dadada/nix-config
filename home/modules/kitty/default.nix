{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.dadada.home.kitty;
in {
  options.dadada.home.kitty = {
    enable = mkEnableOption "Enable kitty config";
  };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      extraConfig = builtins.readFile ./config;
    };
    home.packages = [pkgs.source-code-pro];
  };
}
