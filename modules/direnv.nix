{ config, pkgs, lib, ... }:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNixDirenvIntegration = true;
  };
}
