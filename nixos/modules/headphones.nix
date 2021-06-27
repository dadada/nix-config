{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dadada.headphones;
in
{
  options = {
    dadada.headphones = {
      enable = mkEnableOption "Enable bluetooth headphones with more audio codecs.";
    };
  };
  config = mkIf cfg.enable {
    hardware = {
      bluetooth.enable = true;
      pulseaudio = {
        enable = true;
        extraModules = [ pkgs.pulseaudio-modules-bt ];
        extraConfig = ''
          set-source-volume 1 10000
        '';
        package = pkgs.pulseaudioFull;
      };
    };
  };
}
