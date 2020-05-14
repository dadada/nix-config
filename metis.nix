{ config, pkgs, lib, ... }:
let 
  userEnv = {
    TERMINAL="xterm-256color";
    EDITOR = "vim";
    PAGER = "less";
    MAILDIR = "\$HOME/.var/mail";
    MBLAZE = "\$HOME/.config/mblaze";
    NOTMUCH_CONFIG = "\$HOME/.config/notmuch/config";
    GDK_BACKEND= "x11";
    MOZ_ENABLE_WAYLAND= "1";
    SSH_ASKPASS = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
  };
  unstable = import <nixpkgs-unstable> {};
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
    libnotify
    aspellDicts.en
    aspellDicts.de
    aspellDicts.en-science
    aspellDicts.en-computers
    aspell
    xorg.xev
    evince
    gnumake
    graphviz
    xwayland
    slurp
    grim
    jq
    lxqt.lxqt-openssh-askpass
    xdg_utils
    pwgen
    mkpasswd
    irssi
    mumble
    slic3r
    nfs-utils
    lsof
    samba
    firefox-bin
    chromium
    bc
    brightnessctl
    file
    fzf
    gimp
    gnupg
    inkscape
    inotify-tools
    jmtpfs
    ldns
    libreoffice
    mblaze
    mpv
    nmap
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
    #texlive.combined.scheme-full
    thunderbird-bin
    tor-browser-bundle-bin
    virtmanager
    whois
    youtube-dl
    zathura
    unzip
    anki
    bluez-tools
    texlive-tubslatex
    openssl
    audio-recorder
    qt5.qttools
    emacs
    qt5.qtwayland
    swayidle
    mako
    swaylock
    kanshi
    termite
    bemenu
    xss-lock
    htop
  ] ++ (with unstable; [
    python38Packages.managesieve
    android-studio
    cachix
    keepassxc
    signal-desktop
    libguestfs
  ]);

  services.syncthing = {
    enable = true;
    tray = false;
  };

  services.screen-locker = {
    enable = false;
    inactiveInterval = 5;
    lockCmd = "~/bin/lock-session";
  };

  xdg = {
    enable = true;
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
