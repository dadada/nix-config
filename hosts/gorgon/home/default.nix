{ config, pkgs, lib, ... }:
let
  this = import ../../.. { inherit pkgs; };
in
{
  nixpkgs.overlays = [
    this.overlays.tubslatex
  ];

  imports = lib.attrValues this.hmModules;

  dadada.home = {
    vim.enable = true;
    direnv.enable = true;
    git.enable = true;
    gpg.enable = true;
    gtk.enable = true;
    keyring.enable = true;
    kitty.enable = true;
    ssh.enable = true;
    syncthing.enable = true;
    tmux.enable = true;
    xdg.enable = true;
    zsh.enable = true;

    session = {
      enable = true;
      sessionVars = {
        EDITOR = "vim";
        PAGER = "less";
        MAILDIR = "\$HOME/.var/mail";
        MBLAZE = "\$HOME/.config/mblaze";
        NOTMUCH_CONFIG = "\$HOME/.config/notmuch/config";
        MOZ_ENABLE_WAYLAND = "1";
      };
    };
  };

  # Languagetool server for web extension
  systemd.user.services."languagetool-http-server" = {
    Unit = {
      Description = "Languagetool HTTP server";
      PartOf = [ "graphical-session-pre.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.languagetool}/bin/languagetool-http-server org.languagetool.server.HTTPServer --allow-origin '*'";
      Restart = "always";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = import ./pkgs.nix { pkgs = pkgs; };
}
