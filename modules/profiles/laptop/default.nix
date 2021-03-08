{ config, pkgs, lib, ... }:
with lib;
{
  #nixpkgs.overlays = attrValues (import ../../../overlays);

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.domain = mkDefault "dadada.li";

  dadada = {
    networking = {
      useLocalResolver = mkDefault true;
    };
    autoUpgrade.enable = true;
  };

  services.fwupd.enable = true;

  fonts.fonts = mkDefault (with pkgs; [
    source-code-pro
  ]);

  time.timeZone = mkDefault "Europe/Berlin";

  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  console = mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

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
