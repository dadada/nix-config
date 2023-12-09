{ config
, pkgs
, lib
, ...
}:
with lib; let
  apps = {
    "x-scheme-handler/mailto" = "evolution.desktop";
    "message/rfc822" = "evolution.desktop";
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
    "application/pdf" = "evince.desktop";
  };
  cfg = config.dadada.home.xdg;
in
{
  options.dadada.home.xdg = {
    enable = mkEnableOption "Enable XDG config";
  };
  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      mimeApps = {
        enable = false;
        associations.added = apps;
        defaultApplications = apps;
      };
      userDirs = {
        download = "\$HOME/tmp";
        music = "\$HOME/lib/music";
        videos = "\$HOME/lib/videos";
        pictures = "\$HOME/lib/pictures";
        documents = "\$HOME/lib";
        desktop = "$HOME/tmp";
      };
    };
    home.packages = with pkgs; [
      evince
      firefox
      xdg_utils
    ];
  };
}
