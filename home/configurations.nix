{ self
, nixpkgs
, home-manager
, nix-doom-emacs
, nvd
, scripts
}@inputs:
let
  hmConfiguration =
    { homeDirectory ? "/home/dadada"
    , extraModules ? [ ]
    , overlays ? [ ]
    , system ? "x86_64-linux"
    , username ? "dadada"
    , stateVersion
    }:
    (home-manager.lib.homeManagerConfiguration {
      configuration = { ... }: {
        imports = (nixpkgs.lib.attrValues self.hmModules) ++ extraModules;
        nixpkgs = {
          config = import ./nixpkgs-config.nix {
            pkgs = nixpkgs;
          };
          overlays = overlays;
        };
      };
      inherit system homeDirectory username stateVersion;
    });
in
{
  home = hmConfiguration {
    extraModules = [ ./home ];
    stateVersion = "20.09";
  };

  work = hmConfiguration rec {
    extraModules = [ ./work ];
    homeDirectory = "/home/${username}";
    username = "tim.schubert";
    stateVersion = "20.09";
  };
}
