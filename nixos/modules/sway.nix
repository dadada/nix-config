{ config, pkgs, lib, ... }:
let
  cfg = config.dadada.sway;
in
{
  options = {
    dadada.sway.enable = lib.mkEnableOption "Enable sway";
  };

  config = lib.mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      wrapperFeatures.base = true;
      extraPackages = with pkgs; [
        qt5.qtwayland
        swayidle
        xwayland
        mako
        kanshi
        kitty
        i3status
        bemenu
        xss-lock
        swaylock
        brightnessctl
        playerctl
      ];
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
    };
  };
}
