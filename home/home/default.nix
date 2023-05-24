{ config
, pkgs
, lib
, ...
}:
let
  useFeatures = [
    "alacritty"
    #"emacs"
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
    "helix"
  ];
in
{
  home.stateVersion = "20.09";

  programs.git = {
    signing = {
      key = "D68C84695C087E0F733A28D0EEB8D1CE62C4DFEA";
      signByDefault = true;
    };
    userEmail = "dadada@dadada.li";
    userName = "dadada";
  };

  programs.gpg.settings.default-key = "99658A3EB5CD7C13";

  dadada.home =
    lib.attrsets.genAttrs useFeatures (useFeatures: { enable = true; })
    // {
      session = {
        enable = true;
        sessionVars = {
          EDITOR = "hx";
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

  programs.offlineimap.enable = false;
  xdg.configFile."offlineimap/config".text = ''
    [general]
    accounts = tu-bs,mailbox

    [Account tu-bs]
    localrepository = tu-bs-local
    remoterepository = tu-bs-remote

    [Repository tu-bs-local]
    type = Maildir
    localfolders = ~/lib/backup/y0067212@tu-bs.de

    [Repository tu-bs-remote]
    type = IMAP
    remotehost = mail.tu-braunschweig.de
    remoteuser = y0067212
    sslcacertfile = /etc/ssl/certs/ca-certificates.crt

    [Account mailbox]
    localrepository = mailbox-local
    remoterepository = mailbox-remote

    [Repository mailbox-local]
    type = Maildir
    localfolders = ~/lib/backup/mailbox.org

    [Repository mailbox-remote]
    type = IMAP
    remotehost = imap.mailbox.org
    remoteuser = dadada@dadada.li
    sslcacertfile = /etc/ssl/certs/ca-certificates.crt
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = import ./pkgs.nix { pkgs = pkgs; };
}
