{ config, lib, ... }:
with lib;
let
  cfg = config.dadada.session;
in {
  options.dadada.session = {
    enable = mkEnableOption "Enable session variable management";
    sessionVars = mkOption {
      description = "Session variables";
      type = types.attrs;
      default = {};
      example = ''
        EDITOR = "vim";
        PAGER = "less";
      '';
    };
  };
  config = mkIf cfg.enable {
    home.sessionVariables = cfg.sessionVars;
    systemd.user.sessionVariables = cfg.sessionVars;
  };
}
