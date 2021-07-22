{ self
, nixpkgs
, nixosSystem
, home-manager
, nixos-hardware
}:
let adapterModule = {
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
  nixpkgs.overlays = (nixpkgs.lib.attrValues self.overlays);
};
in
{
  gorgon = nixosSystem {
    system = "x86_64-linux";
    modules = (nixpkgs.lib.attrValues self.nixosModules) ++ [
      adapterModule
      nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen1
      #home-manager.nixosModules.home-manager
      #{
      #  home-manager.useGlobalPkgs = true;
      #  home-manager.useUserPackages = true;
      #  home-manager.users.dadada = self.hmConfigurations.home;
      #}
      ./modules/profiles/laptop.nix
      ./gorgon/configuration.nix
    ];
  };
  ifrit = nixosSystem {
    system = "x86_64-linux";
    modules = (nixpkgs.lib.attrValues self.nixosModules) ++ [
      adapterModule
      ./modules/profiles/server.nix
      ./ifrit/configuration.nix
    ];
  };

  surgat = nixosSystem {
    system = "x86_64-linux";
    modules = (nixpkgs.lib.attrValues self.nixosModules) ++ [
      adapterModule
      ./modules/profiles/server.nix
      ./surgat/configuration.nix
    ];
  };
  pruflas = nixosSystem {
    system = "x86_64-linux";
    modules = (nixpkgs.lib.attrValues self.nixosModules) ++ [
      adapterModule
      ./modules/profiles/server.nix
      ./pruflas/configuration.nix
    ];
  };
}
