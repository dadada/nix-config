{ config, pkgs, ... }:
let
  colors = import ./colors.nix;
in {
  imports = [
    ./vim
    ./tmux.nix
    ./zsh.nix
    (import ./termite.nix {
      config = config;
      pkgs = pkgs;
      colors = colors;
    })
    ./gpg.nix
    ./ssh.nix
    ./git.nix
    ./gtk.nix
    ./xdg.nix
    (import ./mako.nix {
      config = config;
      pkgs = pkgs;
      colors = colors;
    })
    ./keyring.nix
  ];
}
