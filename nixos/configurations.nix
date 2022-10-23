{ self
, agenix
, nixpkgs
, home-manager
, homePage
, nixos-hardware
, nvd
, scripts
, recipemd
, ...
}@inputs:
let
  getDefaultPkgs = system: flakes: nixpkgs.lib.mapAttrs (_: value: nixpkgs.lib.getAttr system value.defaultPackage) flakes;

  nixosSystem = { system ? "x86_64-linux", extraModules ? [ ] }: nixpkgs.lib.nixosSystem {
    inherit system;

    modules = (nixpkgs.lib.attrValues self.nixosModules) ++ [ agenix.nixosModule ] ++ extraModules;
  };
in
{
  gorgon = nixosSystem rec {
    system = "x86_64-linux";

    extraModules = [
      {
        nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;
        dadada.pkgs = (getDefaultPkgs system {
          inherit scripts nvd recipemd;
        }) // self.packages.${system};

        # Add flakes to registry and nix path.
        dadada.inputs = inputs // { dadada = self; };
      }

      nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen1

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.sharedModules = (nixpkgs.lib.attrValues self.hmModules) ++ [
          { manual.manpages.enable = false; }
        ];
        home-manager.users.dadada = import ../home/home;
      }

      ./modules/profiles/laptop.nix
      ./gorgon/configuration.nix
    ];
  };

  ifrit = nixosSystem {
    extraModules = [
      ./modules/profiles/server.nix
      ./ifrit/configuration.nix
      ./ifrit/hardware-configuration.nix
    ];
  };

  surgat = nixosSystem rec {
    system = "x86_64-linux";
    extraModules = [
      {
        dadada.homePage.package = homePage.defaultPackage.${system};
      }
      ./modules/profiles/server.nix
      ./surgat/configuration.nix
    ];
  };

  pruflas = nixosSystem {
    extraModules = [
      ./modules/profiles/laptop.nix
      ./pruflas/configuration.nix
    ];
  };

  agares = nixosSystem {
    extraModules = [
      ./agares/configuration.nix
    ];
  };
}
