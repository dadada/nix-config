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

    jobsets = (import ./jobsets.nix {
      inherit pkgs;
      projectName = "nix-config";
      declInput = {
        src = {
          type = "git";
          value = "git://github.com/dadada/nix-config.git main";
          emailresponsible = false;
        };
        nixpkgs = {
          type = "git";
          value = "git://github.com/NixOS/nixpkgs.git nixpkgs-22.05";
          emailresponsible = false;
        };
      };
    });
  }))
  // {

  hmConfigurations = import ./home/configurations.nix inputs;

  hmModules = import ./home/modules;

  nixosConfigurations = import ./nixos/configurations.nix inputs;

  nixosModules = import ./nixos/modules;

  overlays = import ./overlays.nix;

  hydraJobs = import ./hydra-jobs.nix inputs;

  deploy = import ./deploy.nix inputs;

  checks = import ./checks.nix inputs;
}
