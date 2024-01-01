# Adapted from Mic92/dotfiles
{ self
, flake-utils
, flake-registry
, homePage
, nixpkgs
, home-manager
, nixos-hardware
, agenix
, devshell
, ...
} @ inputs:
(flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };
  in
  {
    devShells.default =
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            agenix.overlays.default
            devshell.overlays.default
          ];
        };
        extraModules = [ "${devshell}/extra/git/hooks.nix" ];
      in
      import ./devshell.nix { inherit pkgs extraModules; };

    formatter = pkgs.nixpkgs-fmt;

    packages = import ./pkgs { inherit pkgs; } // {
      installer-iso = self.nixosConfigurations.installer.config.system.build.isoImage;
    };
  }))
  // {

  hmModules = import ./home/modules;

  nixosConfigurations = import ./nixos/configurations.nix inputs;

  nixosModules = import ./nixos/modules;

  overlays = import ./overlays.nix;

  hydraJobs = import ./hydra-jobs.nix inputs;

  checks = import ./checks.nix inputs;
}
