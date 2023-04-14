{ config
, pkgs
, lib
, ...
}:
with lib; {
  imports = [
    ./backup.nix
    ./base.nix
  ];

  networking.domain = mkDefault "dadada.li";
  networking.tempAddresses = "disabled";

  dadada.admin.enable = true;
  documentation.enable = mkDefault false;
  documentation.nixos.enable = mkDefault false;

  services.journald.extraConfig = ''
    SystemKeepFree = 2G
  '';

  system.autoUpgrade = {
    enable = true;
    flake = "github:dadada/nix-config#${config.networking.hostName}";
    allowReboot = mkDefault true;
    randomizedDelaySec = "45min";
  };

  security.acme = {
    defaults.email = "d553a78d-0349-48db-9c20-5b27af3a1dfc@dadada.li";
    acceptTerms = true;
  };

}
