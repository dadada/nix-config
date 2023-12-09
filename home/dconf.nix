{ lib, ... }:
with lib.hm.gvariant;
{
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/shell" = {
      favorite-apps = [
        "alacritty.desktop"
        "element.desktop"
        "evolution.desktop"
        "firefox.desktop"
        "spotify.desktop"
      ];
    };

    "org/gnome/shell" = {
      disable-user-extensions = true;
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/desktop/input-sources" = {
      current = mkUint32 0;
      per-window = false;
      show-all-sources = true;
      sources = [ (mkTuple [ "xkb" "eu" ]) (mkTuple [ "xkb" "de" ]) ];
      xkb-options = [ "lv3:ralt_switch" "caps:escape" ];
    };

    "org/gnome/desktop/interface" = {
      clock-show-date = true;
      clock-show-seconds = false;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      enable-animations = true;
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Cantarell";
      gtk-enable-primary-paste = false;
      gtk-key-theme = "Emacs";
      gtk-theme = "Adwaita";
      icon-theme = "Adwaita";
      locate-pointer = false;
      monospace-font-name = "JetBrains Mono 10";
      show-battery-percentage = false;
      text-scaling-factor = 1.0;
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = false;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "default";
      natural-scroll = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      send-events = "enabled";
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      disable-microphone = false;
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
      report-technical-problems = false;
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      lock-delay = mkUint32 30;
      lock-enabled = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = false;
      theme-name = "__custom";
    };

    "org/gnome/evince/default" = {
      continuous = true;
      dual-page = false;
      dual-page-odd-left = false;
      enable-spellchecking = true;
      fullscreen = false;
      inverted-colors = false;
      show-sidebar = false;
      sidebar-page = "links";
      sidebar-size = 132;
      sizing-mode = "free";
    };

    "org/gnome/evolution/calendar" = {
      editor-show-timezone = true;
      use-24hour-format = true;
      week-start-day-name = "monday";
      work-day-friday = true;
      work-day-monday = true;
      work-day-saturday = false;
      work-day-sunday = false;
      work-day-thursday = true;
      work-day-tuesday = true;
      work-day-wednesday = true;
    };

    "org/gnome/evolution/mail" = {
      browser-close-on-reply-policy = "always";
      composer-attribution-language = "de_DE";
      composer-reply-start-bottom = false;
      composer-signature-in-new-only = true;
      composer-spell-languages = [ "de" "en_US" ];
      composer-top-signature = false;
      composer-unicode-smileys = false;
      composer-visually-wrap-long-lines = true;
      composer-wrap-quoted-text-in-replies = false;
      forward-style = 0;
      forward-style-name = "attached";
      headers-collapsed = false;
      image-loading-policy = "never";
      junk-check-custom-header = true;
      junk-check-incoming = true;
      junk-empty-on-exit-days = 0;
      junk-lookup-addressbook = false;
      notify-remote-content = true;
      prompt-check-if-default-mailer = false;
      prompt-on-composer-mode-switch = true;
      prompt-on-empty-subject = true;
      prompt-on-expunge = true;
      prompt-on-mark-all-read = false;
      prompt-on-mark-as-junk = true;
      prompt-on-reply-close-browser = "always";
      prompt-on-unwanted-html = true;
      reply-style = 0;
      reply-style-name = "quoted";
      search-gravatar-for-photo = false;
    };

    "org/gnome/evolution/plugin/prefer-plain" = {
      mode = "only_plain";
      show-suppressed = true;
    };

    "org/gnome/gnome-screenshot" = {
      border-effect = "none";
      delay = 0;
      include-border = true;
      include-pointer = false;
      last-save-directory = "file:///home/dadada/lib/pictures/Screenshots";
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      center-new-windows = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      experimental-features = [ ];
      focus-change-on-pointer-rest = true;
      overlay-key = "Super_L";
      workspaces-only-on-primary = true;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      power-button-action = "hibernate";
      power-saver-profile-on-low-battery = true;
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-timeout = 3600;
      sleep-inactive-battery-type = "suspend";
    };

    "org/gnome/system/location" = {
      enabled = false;
    };
  };
}
