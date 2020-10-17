{ config, pkgs, lib, ... }:
{
  services.syncthing = {
    enable = true;
    tray = false;
  };
}
