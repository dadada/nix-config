# Adapted from Mic92/dotfiles
{ self
, flake-utils
, homePage
, nixpkgs
, home-manager
, nixos-hardware
, recipemd
, agenix
, devshell
, helix
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
            agenix.overlay
            devshell.overlays.default
          ];
        };
        extraModules = [ "${devshell}/extra/git/hooks.nix" ];
      in
      import ./devshell.nix { inherit pkgs extraModules; };

    formatter = pkgs.nixpkgs-fmt;

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
          value = "git://github.com/NixOS/nixpkgs.git nixpkgs-22.11";
          emailresponsible = false;
        };
      };
    });

    packages = import ./pkgs { inherit pkgs; };
  }))
  // {

  hmModules = import ./home/modules;

  nixosConfigurations = import ./nixos/configurations.nix inputs;

  nixosModules = import ./nixos/modules;

  overlays = import ./overlays.nix;

  hydraJobs = import ./hydra-jobs.nix inputs;

  checks = import ./checks.nix inputs;
}
