{ config, pkgs, lib, ... }:
let 
  userEnv = {
    EDITOR = "vim";
    PAGER = "less";
    MAILDIR = "\$HOME/.var/mail";
    MBLAZE = "\$HOME/.config/mblaze";
    NOTMUCH_CONFIG = "\$HOME/.config/notmuch/config";
    #GDK_BACKEND= "x11";
    MOZ_ENABLE_WAYLAND= "1";
  };
  unstable = import <nixpkgs-unstable> {};
in
{
  imports = [
    ./common.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables = userEnv;
  systemd.user.sessionVariables = userEnv;


  home.packages = with pkgs; [
    p7zip
    texlive.combined.scheme-full
    wireguard
    ncurses
    tcpdump
    sqlite
    clang
    gitAndTools.git-bug
    pypi2nix
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
    xdg_utils
    pwgen
    mkpasswd
    irssi
    mumble
    slic3r
    nfs-utils
    lsof
    samba
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
    nmap
    pass
    pavucontrol
    clang-tools
    pinentry
    playerctl
    i3blocks
    python3
    python38Packages.dateutil
    spotify
    sshfs-fuse
    tdesktop
    #texlive.combined.scheme-full
    #tor-browser-bundle-bin
    virtmanager
    whois
    youtube-dl
    zathura
    unzip
    anki
    bluez-tools
    #texlive-tubslatex
    openssl
    audio-recorder
    qt5.qttools
    emacs
    qt5.qtwayland
    mako
    kanshi
    termite
    bemenu
    xss-lock
    htop
    gnome3.nautilus
    gnome3.eog
    imagemagick
    corefonts
    mpv
    firefox-bin
    libvirt
    qprint
    apacheHttpd
    netanim
    ns-3
    kitty
    git-lfs
    kcachegrind
    wf-recorder
    ffmpeg
    valgrind
  ] ++ (with unstable; [
    wireshark
    gnuplot
    thunderbird-bin
    keepassxc
    python38Packages.managesieve
    android-studio
    cachix
    signal-desktop
    minecraft
    plantuml
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
