{ config, pkgs, ... }:
{
  imports = [
    ./vim
    ./fish.nix
    ./tmux.nix
    (import ./termite.nix {
      config = config;
      pkgs = pkgs;
      colors = import ./colors.nix;
    })
    ./gpg.nix
    ./ssh.nix
    ./git.nix
    ./gtk.nix
    ./xdg.nix
  ];
}
