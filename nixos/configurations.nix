{ self
, agenix
, nixpkgs
, home-manager
, homePage
, nixos-hardware
, nixos-generators
, ...
}@inputs:
let
  more-packages = system: {
    more-packages = final: prev: {
      recipemd = inputs.recipemd.packages.${system}.recipemd;
    };
  };

  nixosSystem = { system ? "x86_64-linux", extraModules ? [ ] }: nixpkgs.lib.nixosSystem {
    inherit system;

    modules = [{
      # Add flakes to registry and nix path.
      dadada.inputs = inputs // { dadada = self; };
      nixpkgs.overlays = nixpkgs.lib.attrValues (self.overlays // (more-packages system));
    }] ++ (nixpkgs.lib.attrValues self.nixosModules) ++ [ agenix.nixosModules.age ] ++ extraModules;
  };
in
{
  gorgon = nixosSystem rec {
    system = "x86_64-linux";

    extraModules = [
      {
        nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;
        dadada.pkgs = self.packages.${system};
      }

      nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen1

      home-manager.nixosModules.home-manager
      ({ pkgs, lib, ... }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = (nixpkgs.lib.attrValues self.hmModules) ++ [
            { dadada.home.helix.package = pkgs.helix; }
            { manual.manpages.enable = false; }
          ];
          home-manager.users.dadada = import ../home;
        })
      ./gorgon/configuration.nix
    ];
  };

  surgat = nixosSystem rec {
    system = "x86_64-linux";
    extraModules = [
      {
        dadada.homePage.package = homePage;
      }
      ./modules/profiles/server.nix
      ./surgat/configuration.nix
    ];
  };

  agares = nixosSystem {
    extraModules = [
      ./agares/configuration.nix
    ];
  };

  installer = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos-generators.nixosModules.install-iso
      self.nixosModules.admin
      {
        isoImage.isoName = nixpkgs.lib.mkForce "dadada-nixos-installer.iso";
        networking.tempAddresses = "disabled";
        dadada.admin.enable = true;
        documentation.enable = true;
        documentation.nixos.enable = true;
        i18n.defaultLocale = "en_US.UTF-8";
        console = {
          font = "Lat2-Terminus16";
          keyMap = "us";
        };
      }
    ];
  };

  ninurta = nixosSystem {
    extraModules = [
      ./ninurta/configuration.nix
    ];
  };
}
