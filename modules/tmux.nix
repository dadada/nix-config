{ config, ... }:
{
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
}

