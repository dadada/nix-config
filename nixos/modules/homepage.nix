{ config
, lib
, ...
}:
let
  cfg = config.dadada.homePage;
in
with lib; {
  options.dadada.homePage = {
    enable = mkEnableOption "Enable home page";
    package = mkOption {
      type = lib.types.path;
      description = "Path containing the homepage";
    };
  };
  config = mkIf cfg.enable {
    services.nginx.enable = true;

    services.nginx.virtualHosts."dadada.li" = {
      enableACME = true;
      forceSSL = true;
      root = "${cfg.package}";
    };
  };
}
