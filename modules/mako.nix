{ config, pkgs, colors, ...}:
{
  programs.mako = {
    enable = true;
    anchor = "bottom-right";
    backgroundColor = colors.color8;
    borderColor = colors.color0;
    defaultTimeout = -1;
    font = "Source Code Pro 8";
    format = ''<b>%a</b> %s\n%b'';
    height = 100;
    #groupBy = "app-name";
    icons = false;
    ignoreTimeout = false;
    layer = "overlay";
    margin = "0,0,0";
    maxVisible = 200;
    padding = "0";
    progressColor = colors.color4;
    sort = "+time";
    textColor = colors.foreground;
    width = 400;
  };
}
