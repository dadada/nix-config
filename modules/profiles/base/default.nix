{ config, pkgs, lib, ... }:
with lib;
{
  imports = import ../../module-list.nix;

  config = {
    dadada = {
      autoUpgrade.enable = mkDefault true;
      networking = {
        useLocalResolver = mkDefault true;
        domain = mkDefault "dadada.li";
      };
    };

    i18n.defaultLocale = mkDefault "en_US.UTF-8";
    console = {
      font = mkDefault "Lat2-Terminus16";
      keyMap = mkDefault "us";
    };

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
  };
}
