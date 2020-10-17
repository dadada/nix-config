{ config, pkgs, lib, ... }:
let 
  unstable = import <nixpkgs-unstable> {};
in {
  imports = [
    (import ../session.nix {
      inherit config;
      sessionVars = {
        EDITOR = "vim";
        PAGER = "less";
        MAILDIR = "\$HOME/.var/mail";
        MBLAZE = "\$HOME/.config/mblaze";
        NOTMUCH_CONFIG = "\$HOME/.config/notmuch/config";
        MOZ_ENABLE_WAYLAND= "1";
      };
    })
    ../direnv.nix
    ../vim
    ../tmux.nix
    ../zsh.nix
    ../gpg.nix
    ../ssh.nix
    ../git.nix
    ../gtk.nix
    ../xdg.nix
    ../keyring.nix
    ../kitty.nix
    ../syncthing.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    anki
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    bluez-tools
    chromium
    clang
    clang-tools
    evince
    ffmpeg
    fido2luks
    file
    fzf
    gimp
    git-lfs
    gnome3.eog
    gnome3.gnome-tweak-tool
    gnome3.nautilus
    gnumake
    gnupg
    graphviz
    grim
    imagemagick
    inkscape
    inotify-tools
    jq
    kcachegrind
    kitty
    ldns
    libreoffice
    libvirt
    lsof
    mblaze
    mkpasswd
    mpv
    mumble
    ncurses
    nfs-utils
    nmap
    openssl
    p7zip
    pass
    pavucontrol
    playerctl
    pwgen
    python27Packages.dbus-python
    python3
    python38Packages.dateutil
    python38Packages.solo-python
    slurp
    sqlite
    sshfs-fuse
    steam
    tcpdump
    tdesktop
    unzip
    usbutils
    virtmanager
    whois
    xdg_utils
    firefox-bin
    direnv
  ] ++ (with unstable; [
    android-studio
    keepassxc
    minecraft
    python38Packages.managesieve
    signal-desktop
    thunderbird-bin
    wireshark
    youtube-dl
  ]);

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
