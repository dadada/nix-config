{ config, lib, ... }:
with lib;
{
  options.dadada.home.colors = mkOption {
    type = types.attrs;
    description = "Color scheme";
  };

  config = {
    dadada.home.colors = {
      foreground = "#a3a3a3";
      foregroundBold = "#e8e8e8";
      cursor = "#e8e8e8";
      cursorForeground = "#1f2022";
      background = "#292b2e";
      color0 = "#1f2022";
      color8 = "#585858";
      color7 = "#a3a3a3";
      color15 = "#f8f8f8";
      color1 = "#f2241f";
      color9 = "#f2241f";
      color2 = "#67b11d";
      color10 = "#67b11d";
      color3 = "#b1951d";
      color11 = "#b1951d";
      color4 = "#4f97d7";
      color12 = "#4f97d7";
      color5 = "#a31db1";
      color13 = "#a31db1";
      color6 = "#2d9574";
      color14 = "#2d9574";
      color16 = "#ffa500";
      color17 = "#b03060";
      color18 = "#282828";
      color19 = "#444155";
      color20 = "#b8b8b8";
      color21 = "#e8e8e8";
    };
  };
}
