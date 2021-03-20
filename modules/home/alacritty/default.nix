{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dadada.home.alacritty;
in
{
  options.dadada.home.alacritty = {
    enable = mkEnableOption "Enable alacritty config";
  };
  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        scrolling.history = 0;
        font.size = 9;
        shell.program = "tmux";
        window.decorations = "none";
        colors = {
          # Base16 Spacemacs 256 - alacritty color config
          # Nasser Alshammari (https://github.com/nashamri/spacemacs-theme)
          # Default colors
          primary = {
            background = "0x1f2022";
            foreground = "0xa3a3a3";
          };

          # Colors the cursor will use if `custom_cursor_colors` is true
          cursor = {
            text = "0x1f2022";
            cursor = "0xa3a3a3";
          };

          # Normal colors
          normal = {
            black = "0x1f2022";
            red = "0xf2241f";
            green = "0x67b11d";
            yellow = "0xb1951d";
            blue = "0x4f97d7";
            magenta = "0xa31db1";
            cyan = "0x2d9574";
            white = "0xa3a3a3";
          };

          # Bright colors
          bright = {
            black = "0x585858";
            red = "0xf2241f";
            green = "0x67b11d";
            yellow = "0xb1951d";
            blue = "0x4f97d7";
            magenta = "0xa31db1";
            cyan = "0x2d9574";
            white = "0xf8f8f8";
          };

          indexed_colors = [
            { index = 16; color = "0xffa500"; }
            { index = 17; color = "0xb03060"; }
            { index = 18; color = "0x282828"; }
            { index = 19; color = "0x444155"; }
            { index = 20; color = "0xb8b8b8"; }
            { index = 21; color = "0xe8e8e8"; }
          ];
        };
      };
    };
  };
}
