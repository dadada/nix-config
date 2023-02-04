{ config
, pkgs
, lib
, ...
}:
let
  secretsPath = config.dadada.secrets.path;
in
with lib; {
  imports = [
    ./backup.nix
    ./base.nix
  ];

  networking.domain = mkDefault "dadada.li";

  services.fwupd.enable = mkDefault true;

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  fonts.fonts = mkDefault (with pkgs; [
    source-code-pro
  ]);

  users.mutableUsers = mkDefault true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = mkDefault true;
  boot.loader.efi.canTouchEfiVariables = mkDefault true;

  services.fstrim.enable = mkDefault true;

  services.avahi.enable = mkDefault true;

  networking.networkmanager.enable = mkDefault true;
  networking.firewall.enable = mkDefault true;

  services.xserver.enable = mkDefault true;
  services.xserver.displayManager.gdm.enable = mkDefault true;
  services.xserver.desktopManager.gnome.enable = mkDefault true;

  xdg.mime.enable = mkDefault true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;

  dadada.backupClient.gs = {
    enable = true;
    passphrasePath = config.age.secrets."${config.networking.hostName}-backup-passphrase-gs".path;
  };

  age.secrets."${config.networking.hostName}-backup-passphrase-gs".file = "${secretsPath}/${config.networking.hostName}-backup-passphrase-gs.age";
}
