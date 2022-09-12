{ self, pkgs, agenix, deploy-rs, system, ... }:
let
  selfApp = app: self.apps."${app}";
in
pkgs.mkShell {
  buildInputs = pkgs.lib.catAttrs "system" [
    agenix.defaultPackage
    deploy-rs.defaultPackage
    (pkgs.lib.getAttrs [ "deploy" "update" "nixos-switch" ] self.apps)
  ];
}
