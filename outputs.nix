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
, devshell
, helix
, ...
} @ inputs:
(flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    selfPkgs = self.packages.${system};
    formatter = self.formatter.${system};
  in
  {
    devShells.default =
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            agenix.overlay
            devshell.overlay
          ];
        };
        extraModules = [ "${devshell}/extra/git/hooks.nix" ];
      in
      import ./devshell.nix { inherit pkgs extraModules; };

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

    packages = import ./pkgs (inputs // { inherit pkgs; });
  }))
  // {

  hmModules = import ./home/modules;

  nixosConfigurations = import ./nixos/configurations.nix inputs;

  nixosModules = import ./nixos/modules;

  overlays = import ./overlays.nix;

  hydraJobs = import ./hydra-jobs.nix inputs;

  checks = import ./checks.nix inputs;
}
