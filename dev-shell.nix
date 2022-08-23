{ pkgs, agenix, deploy-rs, system, ... }:
pkgs.mkShell {
  buildInputs = [
    agenix.defaultPackage."${system}"
    deploy-rs.defaultPackage."${system}"
  ];
}
