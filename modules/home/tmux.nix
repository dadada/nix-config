{ config, lib, ... }:
with lib;
let
  cfg = config.dadada.home.tmux;
in {
  options.dadada.home.tmux = {
    enable = mkEnableOption "Enable tmux config";
  };
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      terminal = "xterm-256color";
      extraConfig = ''
          set -g status on
          set-option -g set-titles on
          set-option -g automatic-rename on
          set-window-option -g mode-keys vi
      '';
    };
  };
}
