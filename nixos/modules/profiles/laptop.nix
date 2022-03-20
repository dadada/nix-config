{ config, pkgs, lib, ... }:
with lib;
{
  networking.domain = mkDefault "dadada.li";

  services.fwupd.enable = mkDefault true;

  fonts.fonts = mkDefault (with pkgs; [
    source-code-pro
  ]);

  time.timeZone = mkDefault "Europe/Berlin";

  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  console.keyMap = mkDefault "us";

  users.mutableUsers = mkDefault true;

  programs.zsh = mkDefault {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    histSize = 100000;
    vteIntegration = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "pattern" "root" "line" ];
    };
  };

  virtualisation = {
    libvirtd.enable = mkDefault true;
    docker.enable = mkDefault true;
    docker.liveRestore = false;
  };

  virtualisation.docker.extraOptions = mkDefault "--bip=192.168.1.5/24";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = mkDefault true;
  boot.loader.efi.canTouchEfiVariables = mkDefault true;

  services.fstrim.enable = mkDefault true;

  services.avahi.enable = false;

  networking.networkmanager.enable = mkDefault true;
  networking.firewall.enable = mkDefault true;

  services.xserver.enable = mkDefault true;
  services.xserver.displayManager.gdm.enable = mkDefault true;
  services.xserver.desktopManager.gnome.enable = mkDefault true;

  xdg.mime.enable = mkDefault true;
}
