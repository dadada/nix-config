{ config, pkgs, lib, ... }:
with lib;
{
  imports = import ../../module-list.nix ++ [
    ../base
  ];

  dadada = {
    networking = {
      useLocalResolver = mkDefault true;
      domain = mkDefault "dadada.li";
    };
  };

  services.fwupd.enable = true;

  fonts.fonts = mkDefault (with pkgs; [
    source-code-pro
  ]);

  time.timeZone = mkDefault "Europe/Berlin";

  programs.zsh = mkDefault {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    histSize = 100000;
    vteIntegration = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "pattern" "cursor" "root" "line" ];
    };
  };
}
