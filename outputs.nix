# Adapted from Mic92/dotfiles
{ self
, flake-utils
, homePage
, nixpkgs
, home-manager
, nix-doom-emacs
, nixos-hardware
, nvd
, scripts
, recipemd
, agenix
, ...
} @ inputs:
(flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    selfPkgs = self.packages.${system};
    formatter = self.formatter.${system};
    agenix-bin = agenix.defaultPackage."${system}";
  in
  {
    apps = import ./apps.nix { inherit pkgs; };

    devShells.default = pkgs.callPackage ./dev-shell.nix { inherit pkgs agenix-bin; };

    formatter = nixpkgs.legacyPackages."${system}".nixpkgs-fmt;

    checks = import ./checks.nix { inherit formatter pkgs; };
  }))
  // {

  hmConfigurations = import ./home/configurations.nix inputs;

  hmModules = import ./home/modules inputs;

  nixosConfigurations = import ./nixos/configurations.nix (inputs // {
    admins = import ./admins.nix;
    secretsPath = ./secrets;
  });

  nixosModules = import ./nixos/modules inputs;

  overlays = import ./overlays;

  hydraJobs = import ./hydra-jobs.nix inputs;
}
