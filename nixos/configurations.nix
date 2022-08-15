# TODO refactor adapterModule and redundant module config
{ self
, admins
, agenix
, nixpkgs
, home-manager
, homePage
, nixos-hardware
, nvd
, scripts
, recipemd
, secretsPath
, ...
}:
let
  nixosSystem = nixpkgs.lib.nixosSystem;
  agenixModule = agenix.nixosModule;
  adapterModule = system: {
    nixpkgs.config.allowUnfreePredicate = pkg: true;
    nixpkgs.overlays =
      (nixpkgs.lib.attrValues self.overlays)
      ++ [
        (final: prev: { homePage = homePage.defaultPackage.${system}; })
        (final: prev: { s = scripts; })
        (final: prev: { n = nvd; })
        (final: prev: { recipemd = recipemd.defaultPackage.${system}; })
      ];
  };
  lib = nixpkgs.lib;
in
{
  gorgon = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = { inherit admins secretsPath; };
    modules =
      (nixpkgs.lib.attrValues self.nixosModules)
      ++ [
        (adapterModule system)
        agenixModule
        nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen1
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules =
            (nixpkgs.lib.attrValues self.hmModules)
            ++ [
              { manual.manpages.enable = false; }
            ];
          home-manager.users.dadada = import ../home/home;
        }
        ./modules/profiles/laptop.nix
        ./gorgon/configuration.nix
      ];
  };
  ifrit = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = { inherit admins secretsPath; };
    modules =
      (nixpkgs.lib.attrValues self.nixosModules)
      ++ [
        agenixModule
        (adapterModule system)
        ./modules/profiles/server.nix
        ./ifrit/configuration.nix
        ./ifrit/hardware-configuration.nix
      ];
  };

  surgat = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = { inherit admins secretsPath; };
    modules =
      (nixpkgs.lib.attrValues self.nixosModules)
      ++ [
        (adapterModule system)
        agenixModule
        ./modules/profiles/server.nix
        ./surgat/configuration.nix
      ];
  };
  pruflas = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = { inherit admins secretsPath; };
    modules =
      (nixpkgs.lib.attrValues self.nixosModules)
      ++ [
        (adapterModule system)
        agenixModule
        ./modules/profiles/laptop.nix
        ./pruflas/configuration.nix
      ];
  };

  agares = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = { inherit admins secretsPath; };
    modules =
      (nixpkgs.lib.attrValues self.nixosModules)
      ++ [
        (adapterModule system)
        agenixModule
        ./modules/profiles/server.nix
        ./agares/configuration.nix
      ];
  };
}
