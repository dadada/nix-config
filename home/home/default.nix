{ config, pkgs, lib, ... }:
let
  useFeatures = [
    "alacritty"
    "emacs"
    "vim"
    "direnv"
    "git"
    "gpg"
    "gtk"
    "keyring"
    "syncthing"
    "tmux"
    "xdg"
    "zsh"
  ];
in
{
  programs.git = {
    signing = {
      key = "D68C84695C087E0F733A28D0EEB8D1CE62C4DFEA";
      signByDefault = true;
    };
    userEmail = "dadada@dadada.li";
    userName = "dadada";
  };

  programs.gpg.settings.default-key = "99658A3EB5CD7C13";

  dadada.home = lib.attrsets.genAttrs useFeatures (useFeatures: { enable = true; }) // {
    session = {
      enable = true;
      sessionVars = {
        EDITOR = "vim";
        PAGER = "less";
        MAILDIR = "\$HOME/.var/mail";
        MBLAZE = "\$HOME/.config/mblaze";
        NOTMUCH_CONFIG = "\$HOME/.config/notmuch/config";
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
