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
        set -g automatic-rename on
        setw -g mode-keys vi
        set -g mouse on
        set -g set-clipboard external
        set -g set-titles on
        set -g status on
      '';
    };
  };
}
