{ config, pkgs, lib, ... }:
{
  imports = [
    (import ../session.nix {
      inherit config;
      sessionVars = {
        EDITOR = "vim";
        PAGER = "less";
        MOZ_ENABLE_WAYLAND= "1";
      };
    })
    ../vim
    ../direnv.nix
    ../git.nix
    ../gpg.nix
    ../gtk.nix
    ../keyring.nix
    ../kitty.nix
    ../ssh.nix
    ../tmux.nix
    ../zsh.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    file
    gnupg
    libreoffice
    python3
    sshfs-fuse
    unzip
  ];

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
