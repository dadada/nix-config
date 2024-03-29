{ self
, flake-utils
, nixpkgs
, ...
}:
(flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    formatter = self.formatter.${system};
  in
  {
    checks = {
      format = pkgs.runCommand
        "check-format"
        {
          buildInputs = [ formatter ];
        }
        "${formatter}/bin/nixpkgs-fmt --check ${./.} && touch $out";
    };
  })).checks
