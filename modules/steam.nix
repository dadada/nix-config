{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dadada.steam;
in
{
  options.dadada.steam = {
    enable = mkEnableOption "Enable Steam config";
  };
  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };

    hardware.pulseaudio.support32Bit = true;
  };
}
