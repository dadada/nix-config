# Adapted from Mic92/dotfiles
{ self
, flake-utils
, nixpkgs
, home-manager
, nix-doom-emacs
, nixos-hardware
, nvd
, ...
}@inputs:
(flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    selfPkgs = self.packages.${system};
    pythonPackages = import ./pkgs/python-pkgs;
    python3Packages = pythonPackages { callPackage = pkgs.python3Packages.callPackage; };
    #lib = import ./lib;
  in
  {
    apps.deploy = {
      type = "app";
      program = toString (pkgs.writeScript "deploy" ''
        #!${pkgs.runtimeShell}
        domain='dadada.li'
        flake=$(nix flake metadata --json ${./.} | jq -r .url)
        nixos-rebuild switch --upgrade --flake "''${flake}#$1" --target-host "''${1}.$domain" --build-host localhost --use-remote-sudo
      '');
    };
    apps.hm-switch = {
      type = "app";
      program = toString (pkgs.writeScript "hm-switch" ''
        #!${pkgs.runtimeShell}
        set -eu -o pipefail -x
        tmpdir=$(mktemp -d)
        export PATH=${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.nixFlakes pkgs.jq ]}
        trap "rm -rf $tmpdir" EXIT
        declare -A profiles=(["gorgon"]="home" ["timsch-nb"]="work")
        profile=''${profiles[$HOSTNAME]:-common}
        flake=$(nix flake metadata --json ${./.} | jq -r .url)
        nix build --show-trace --out-link "$tmpdir/result" "$flake#hmConfigurations.''${profile}.activationPackage" "$@"
        link=$(realpath $tmpdir/result)
        $link/activate
      '');
    };
    apps.recipemd = {
      type = "app";
      program = "${selfPkgs.recipemd}/bin/recipemd";
    };
    devShell = pkgs.callPackage ./shell.nix {
      deploy = selfPkgs.deploy;
    };
    packages = flake-utils.lib.flattenTree {
      deploy = pkgs.callPackage ./pkgs/deploy.nix { };
      scripts = pkgs.callPackage ./pkgs/scripts.nix { };
      keys = pkgs.callPackage ./pkgs/keys { };
      homePage = pkgs.callPackage ./pkgs/homePage { };
      recipemd = pkgs.python3Packages.toPythonApplication python3Packages.recipemd;
    };
  })) // {
  hmConfigurations = import ./home/configurations.nix {
    inherit self nixpkgs home-manager nix-doom-emacs nvd;
  };
  hmModules = import ./home/modules inputs;
  nixosConfigurations = import ./nixos/configurations.nix {
    nixosSystem = nixpkgs.lib.nixosSystem;
    inherit self nixpkgs home-manager nixos-hardware;
  };
  nixosModules = import ./nixos/modules inputs;
  overlays = import ./overlays;
  pythonPackages = import ./pkgs/python-pkgs;

  hydraJobs = (
    nixpkgs.lib.mapAttrs'
      (name: config: nixpkgs.lib.nameValuePair name config.config.system.build.toplevel)
      self.nixosConfigurations
  ) // (nixpkgs.lib.mapAttrs'
    (name: config: nixpkgs.lib.nameValuePair name config.activation-script)
    self.hmConfigurations
  ) // (let tests = import ./tests; in flake-utils.lib.eachDefaultSystem tests);
}
