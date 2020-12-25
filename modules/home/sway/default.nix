{ config, pkgs, lib, colors, ...}:
with lib;
let
  cfg = config.dadada.home.sway;
in {
  options.dadada.home.sway = {
    enable = mkEnableOption "Enable Sway config";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      qt5.qtwayland
      swayidle
      xwayland
      mako
      kanshi
      i3blocks
      termite
      bemenu
      xss-lock
    ] ++ (with unstable; [
      swaylock
    ]);

    wayland.windowManager.sway =  {
      enable = true;
      config = null;
      extraConfig = (builtins.readFile ./config);
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
