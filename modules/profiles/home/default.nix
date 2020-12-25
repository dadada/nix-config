{ config, pkgs, lib, ... }:
let 
  sources = import ../../../nix/sources.nix;
  stable = import <nixpkgs-stable> {};
in {
  nixpkgs = {
    overlays = [
      (import ../../../overlays/texlive-tubslatex.nix)
    ];
  };

  imports = import ../../module-list.nix;

  dadada = {
    vim.enable = true;
    direnv.enable = true;
    git.enable = true;
    gpg.enable = true;
    gtk.enable = true;
    keyring.enable = true;
    kitty.enable = true;
    session.enable = true;
    ssh.enable = true;
    syncthing.enable = true;
    xdg.enable = true;
    zsh.enable = true;
  };

  dadada.session = {
    sessionVars = {
      EDITOR = "vim";
      PAGER = "less";
      MAILDIR = "\$HOME/.var/mail";
      MBLAZE = "\$HOME/.config/mblaze";
      NOTMUCH_CONFIG = "\$HOME/.config/notmuch/config";
      MOZ_ENABLE_WAYLAND= "1";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = import ./pkgs.nix { pkgs = pkgs; };

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
