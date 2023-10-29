{ config, lib, ... }:
let
  mkDefault = lib.mkDefault;
  inputs = config.dadada.inputs;
in
{
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  console = mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  time.timeZone = mkDefault "Europe/Berlin";

  nix.nixPath = lib.mapAttrsToList (name: value: "${name}=${value}") inputs;
  nix.registry = lib.mapAttrs' (name: value: lib.nameValuePair name { flake = value; }) inputs;
  nix.settings.flake-registry = "${config.dadada.inputs.flake-registry}/flake-registry.json";

  nix.settings.substituters = [ https://cache.nixos.org/ ];

  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "gorgon:eEE/PToceRh34UnnoFENERhk89dGw5yXOpJ2CUbfL/Q="
  ];

  nix.settings.require-sigs = true;

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

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

  networking.networkmanager.dns = mkDefault "systemd-resolved";
  services.resolved = {
    enable = mkDefault true;
    fallbackDns = [ "9.9.9.9#dns.quad9.net" "2620:fe::fe:11#dns11.quad9.net" ];
  };
}

