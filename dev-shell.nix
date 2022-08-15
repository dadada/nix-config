{ pkgs, agenix-bin, ... }:
pkgs.mkShell {
  buildInputs = [
    agenix-bin
  ];
}
