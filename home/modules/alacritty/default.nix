{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.dadada.home.alacritty;
in
{
  options.dadada.home.alacritty = {
    enable = mkEnableOption "Enable alacritty config";
  };
  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [
      pkgs.jetbrains-mono
    ];
    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        scrolling.history = 0;
        font = {
          size = 9;
          normal = {
            family = "Jetbrains Mono";
            style = "Regular";
          };
          bold = {
            family = "Jetbrains Mono";
            style = "Bold";
          };
          italic = {
            family = "Jetbrains Mono";
            style = "Italic";
          };
          bold_italic = {
            family = "Jetbrains Mono";
            style = "Bold Italic";
          };
        };
        shell.program = "tmux";
        window.decorations = "none";
        colors = lib.trivial.importTOML ./colors.toml;
      };
    };
  };
}
