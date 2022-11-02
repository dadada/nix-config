{ config, pkgs, lib, ... }:
let
  cfg = config.dadada.home.helix;
in
{
  options.dadada.home.helix = {
    enable = lib.mkEnableOption "Enable helix editor";
    package = lib.mkOption {
      type = lib.types.package;
      description = "Helix editor package to use";
      default = pkgs.helix;
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".config/helix".source = ./config;
    home.packages = [
      cfg.package
      pkgs.rnix-lsp
    ];
  };
}
