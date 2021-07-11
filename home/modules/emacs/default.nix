{ nix-doom-emacs, ... }:
{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dadada.home.emacs;
in
{
  imports = [ nix-doom-emacs.hmModule ];
  options.dadada.home.emacs = {
    enable = mkEnableOption "Enable dadada emacs config";
  };
  config = mkIf cfg.enable {
    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ./doom.d;
    };
    services.emacs = {
      enable = true;
      socketActivation.enable = true;
    };
  };
}
