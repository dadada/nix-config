{ self
, nixpkgs
, home-manager
, nix-doom-emacs
, ...
} @ inputs:
let
  hmConfiguration =
    { homeDirectory ? "/home/dadada"
    , extraModules ? [ ]
    , system ? "x86_64-linux"
    , username ? "dadada"
    , stateVersion
    }: (home-manager.lib.homeManagerConfiguration {
      configuration = { ... }: {
        imports = (nixpkgs.lib.attrValues self.hmModules) ++ extraModules;

        nixpkgs = {
          config = import ./nixpkgs-config.nix {
            pkgs = nixpkgs;
          };
        };

        manual.manpages.enable = false;
      };
      inherit system homeDirectory username stateVersion;
    });
in
{
  home = hmConfiguration {
    extraModules = [ ./home nix-doom-emacs.hmModule ];
    stateVersion = "20.09";
  };
}
