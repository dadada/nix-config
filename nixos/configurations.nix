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
        home-manager.sharedModules = (nixpkgs.lib.attrValues self.hmModules) ++ [
          { manual.manpages.enable = false;}
        ];
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
