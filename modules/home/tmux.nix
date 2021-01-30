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
        set -g mouse on
        set -g set-clipboard on
        bind-key -Tcopy-mode v send -X begin-selection
        bind-key -Tcopy-mode y send -X copy-selection
        set -g status on
        set-option -g set-titles on
        set-option -g automatic-rename on
        set-window-option -g mode-keys vi
      '';
    };
  };
}
