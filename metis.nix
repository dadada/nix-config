{ config, pkgs, lib, ... }:
let 
  userEnv = {
    EDITOR = "vim";
    PAGER = "less";
    MAILDIR = "\$HOME/.var/mail";
    MBLAZE = "\$HOME/.config/mblaze";
    MBLAZE_PAGER = "cat";
    NOTMUCH_CONFIG = "\$HOME/.config/notmuch/config";
    PASSWORD_STORE_DIR = "\$HOME/src/password-store";
    SSH_AGENT_SOCKET = "\$XDG_RUNTIME_DIR/ssh-agent";
  };
in
{
  imports = [
    ./common.nix
    ./private/metis
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables = userEnv;
  systemd.user.sessionVariables = userEnv;

  home.packages = with pkgs; [
    firefox-bin
    chromium
    android-studio
    bc
    brightnessctl
    file
    fzf
    gimp
    gnupg
    inkscape
    inotify-tools
    jmtpfs
    keepassxc
    ldns
    libreoffice
    mblaze
    mpv
    nmap
    pandoc
    pass
    pavucontrol
    pinentry
    playerctl
    i3blocks
    python3
    python38Packages.dateutil
    spotify
    sshfs-fuse
    tdesktop
    texlive.combined.scheme-full
    thunderbird-bin
    tor-browser-bundle-bin
    virtmanager
    whois
    youtube-dl
    zathura
    unzip
    anki
    bluez-tools
  ];

  services.syncthing = {
    enable = true;
    tray = false;
  };

  services.screen-locker = {
    enable = true;
    inactiveInterval = 5;
    lockCmd = "\${pkgs.swaylock}/bin/swaylock";
  };

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      #associations.added = {
      #};
      #defaultApplications = {
      #};
    };
    userDirs = {
      download ="\$HOME/tmp";
      music = "\$HOME/lib/music";
      videos ="\$HOME/lib/videos";
      pictures = "\$HOME/lib/pictures";
      documents = "\$HOME/lib";
      desktop = "$HOME/tmp";
    };
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
