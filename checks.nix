{ pkgs, formatter }:
{
  format = pkgs.runCommand
    "check-format"
    {
      buildInputs = [ formatter ];
    }
    "${formatter}/bin/nixpkgs-fmt --check ${./.} && touch $out";
}
