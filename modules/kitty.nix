{ pkgs, lib, config, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.source-code-pro;
      name = "Source Code Pro 10";
    };
    extraConfig = ''
      enable_audio_bell = false;
      background #1f2022
      foreground #a3a3a3
      selection_background #a3a3a3
      selection_foreground #1f2022
      url_color #b8b8b8
      cursor #a3a3a3
      active_border_color #585858
      inactive_border_color #282828
      active_tab_background #1f2022
      active_tab_foreground #a3a3a3
      inactive_tab_background #282828
      inactive_tab_foreground #b8b8b8
      tab_bar_background #282828

      # normal
      color0 #1f2022
      color1 #f2241f
      color2 #67b11d
      color3 #b1951d
      color4 #4f97d7
      color5 #a31db1
      color6 #2d9574
      color7 #a3a3a3

      # bright
      color8 #585858
      color9 #f2241f
      color10 #67b11d
      color11 #b1951d
      color12 #4f97d7
      color13 #a31db1
      color14 #2d9574
      color15 #f8f8f8

      # extended base16 colors
      color16 #ffa500
      color17 #b03060
      color18 #282828
      color19 #444155
      color20 #b8b8b8
      color21 #e8e8e8
    '';
  };
}
