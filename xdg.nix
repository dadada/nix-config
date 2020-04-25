{ config, pkgs, lib, ... }:
let
  apps = {
    "x-scheme-handler/mailto" = "userapp-Thunderbird-PB7NI0.desktop";
    "message/rfc822" = "userapp-Thunderbird-PB7NI0.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/ftp" = "firefox.desktop";
    "x-scheme-handler/chrome" = "firefox.desktop";
    "text/html" = "firefox.desktop";
    "application/x-extension-htm" = "firefox.desktop";
    "application/x-extension-html" = "firefox.desktop";
    "application/x-extension-shtml" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "application/x-extension-xhtml" = "firefox.desktop";
    "application/x-extension-xht" = "firefox.desktop";
    "text/plain" = "vim.desktop";
    "application/pdf" = "org.pwmt.zathura.desktop";
  };
in {
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = apps;
      defaultApplications = apps;
    };
  };
  home.packages = with pkgs; [
    firefox-bin
    xdg_utils
    zathura
  ];
}
