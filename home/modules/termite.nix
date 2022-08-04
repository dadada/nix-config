{
  config,
  lib,
  pkgs,
  colors ? ../../lib/colors.nix,
  ...
}:
with lib; let
  cfg = config.dadada.home.termite;
in {
  options.dadada.home.termite = {
    enable = mkEnableOption "Enable termite config";
  };
  config = mkIf cfg.enable {
    programs.termite = {
      enable = true;
      allowBold = true;
      audibleBell = false;
      clickableUrl = true;
      dynamicTitle = true;
      font = "Source Code Pro 10";
      mouseAutohide = false;
      scrollOnOutput = false;
      scrollOnKeystroke = true;
      scrollbackLines = -1;
      searchWrap = true;
      urgentOnBell = true;
      cursorBlink = "off";
      cursorShape = "block";
      sizeHints = false;
      scrollbar = "off";
      colorsExtra = ''
        foreground = ${colors.foreground}
        foreground_bold = ${colors.foregroundBold}
        cursor = ${colors.cursor}
        cursor_foreground = ${colors.cursorForeground}
        background = ${colors.background}
        color0  = ${colors.background}
        color8  = ${colors.color8}
        color7  = ${colors.color7}
        color15 = ${colors.color15}
        color1  = ${colors.color1}
        color9  = ${colors.color9}
        color2  = ${colors.color2}
        color10 = ${colors.color10}
        color3  = ${colors.color3}
        color11 = ${colors.color11}
        color4  = ${colors.color4}
        color12 = ${colors.color12}
        color5  = ${colors.color5}
        color13 = ${colors.color13}
        color6  = ${colors.color6}
        color14 = ${colors.color14}
        color16 = ${colors.color16}
        color17 = ${colors.color17}
        color18 = ${colors.color18}
        color19 = ${colors.color19}
        color20 = ${colors.color20}
        color21 = ${colors.color21}
      '';
    };

    # Add font that is used in config
    home.packages = [
      pkgs.source-code-pro
    ];
  };
}
