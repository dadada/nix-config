{ self
, nixpkgs
, nixosSystem
, home-manager
, homePage
, nixos-hardware
, nvd
, scripts
}:
let adapterModule = system: {
  nix.nixPath = [
    "home-manager=${home-manager}"
    "nixpkgs=${nixpkgs}"
    "dadada=${self}"
  ];
  nix.registry = {
    home-manager.flake = home-manager;
    nixpkgs.flake = nixpkgs;
    dadada.flake = self;
  };
  nix.binaryCaches = [
    https://cache.nixos.org/
    https://nix-community.cachix.org/
  ];
  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "gorgon:eEE/PToceRh34UnnoFENERhk89dGw5yXOpJ2CUbfL/Q="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  nix.requireSignedBinaryCaches = true;
  nix.useSandbox = true;
  nixpkgs.overlays = (nixpkgs.lib.attrValues self.overlays) ++ [
    (final: prev: { homePage = homePage.defaultPackage.${system}; })
    (final: prev: { s = scripts; })
    (final: prev: { n = nvd; })
  ];
};
in
{
  gorgon = nixosSystem rec {
    system = "x86_64-linux";
    modules = (nixpkgs.lib.attrValues self.nixosModules) ++ [
      (adapterModule system)
      nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen1
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.sharedModules = (nixpkgs.lib.attrValues self.hmModules);
        home-manager.users.dadada = import ../home/home;
      }
      ./modules/profiles/laptop.nix
      ./gorgon/configuration.nix
    ];
  };
  ifrit = nixosSystem rec {
    system = "x86_64-linux";
    modules = (nixpkgs.lib.attrValues self.nixosModules) ++ [
      (adapterModule system)
      ./modules/profiles/server.nix
      ./ifrit/configuration.nix
    ];
  };

  surgat = nixosSystem rec {
    system = "x86_64-linux";
    modules = (nixpkgs.lib.attrValues self.nixosModules) ++ [
      (adapterModule system)
      ./modules/profiles/server.nix
      ./surgat/configuration.nix
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.sharedModules = (nixpkgs.lib.attrValues self.hmModules);
        home-manager.users.dadada = import ../home/work;
      }
    ];
  };
  pruflas = nixosSystem rec {
    system = "x86_64-linux";
    modules = (nixpkgs.lib.attrValues self.nixosModules) ++ [
      (adapterModule system)
      ./modules/profiles/server.nix
      ./pruflas/configuration.nix
    ];
  };
}
