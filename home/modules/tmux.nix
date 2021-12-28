{ config, lib, ... }:
with lib;
let
  cfg = config.dadada.home.tmux;
in
{
  options.dadada.home.tmux = {
    enable = mkEnableOption "Enable tmux config";
  };
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      terminal = "xterm-256color";
      extraConfig = ''
        setw -g mode-keys vi
        set -g mouse on
        set -g set-clipboard external
        set -g set-titles on
        set -g status on
        set-option -g status-interval 5
        set-option -g automatic-rename on
        set-option -g automatic-rename-format '#{b:pane_current_path}'
      '';
    };
  };
}
