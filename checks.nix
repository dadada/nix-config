{ self
, deploy-rs
, flake-utils
, nixpkgs
, ...
}:
#builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib //
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
    } // deploy-rs.lib."${system}".deployChecks self.deploy;
  })).checks
