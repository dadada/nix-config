{ config, pkgs, lib, ... }:
let 
  userEnv = {
    EDITOR = "vim";
    PAGER = "less";
  };
in
{
  imports = [
    ./common.nix
    #./private/work
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables = userEnv;

  home.packages = with pkgs; [
    firefox-bin
    chromium
    android-studio
    file
    fzf
    gnupg
    libreoffice
    pinentry
    python3
    spotify
    sshfs-fuse
    unzip
  ];

  programs.bash = {
    enable = true;
    initExtra = ''
      exec fish
    '';
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";
}
