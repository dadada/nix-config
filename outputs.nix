# Adapted from Mic92/dotfiles
{ self
, deploy-rs
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
  in
  {
    apps = import ./apps.nix (inputs // { inherit pkgs system; });

    devShells.default = pkgs.callPackage ./dev-shell.nix inputs // { inherit pkgs system; };

    formatter = nixpkgs.legacyPackages."${system}".nixpkgs-fmt;
  }))
  // {

  hmConfigurations = import ./home/configurations.nix inputs;

  hmModules = import ./home/modules inputs;

  nixosConfigurations = import ./nixos/configurations.nix (inputs // {
    admins = import ./admins.nix;
    secretsPath = ./secrets;
  });

  nixosModules = import ./nixos/modules inputs;

  overlays = import ./overlays.nix;

  hydraJobs = import ./hydra-jobs.nix inputs;

  deploy = import ./deploy.nix inputs;

  checks = import ./checks.nix inputs;
}
