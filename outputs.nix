# Adapted from Mic92/dotfiles
{ self
, flake-utils
, homePage
, nixpkgs
, home-manager
, nix-doom-emacs
, nixos-hardware
, nvd
, scripts
, recipemd
, ...
}@inputs:
(flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    selfPkgs = self.packages.${system};
  in
  {
    apps.nixos-switch = {
      type = "app";
      program = toString (pkgs.writeScript "deploy" ''
        #!${pkgs.runtimeShell}
        flake=$(nix flake metadata --json ${./.} | jq -r .url)
        nixos-rebuild switch --flake ".#$1" --use-remote-sudo
      '');
    };
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
        declare -A profiles=(["gorgon"]="home")
        profile=''${profiles[$HOSTNAME]:-common}
        flake=$(nix flake metadata --json ${./.} | jq -r .url)
        nix build --out-link "$tmpdir/result" "$flake#hmConfigurations.''${profile}.activationPackage" "$@"
        link=$(realpath $tmpdir/result)
        $link/activate
      '');
    };
    devShell = pkgs.callPackage ./shell.nix { };
  })) // {
  hmConfigurations = import ./home/configurations.nix {
    inherit self nixpkgs home-manager;
  };
  hmModules = import ./home/modules inputs;
  nixosConfigurations = import ./nixos/configurations.nix {
    nixosSystem = nixpkgs.lib.nixosSystem;
    inherit self nixpkgs home-manager nixos-hardware nvd scripts homePage recipemd;
  };
  nixosModules = import ./nixos/modules inputs;
  overlays = import ./overlays;
  keys = ./keys;

  hydraJobs = (
    nixpkgs.lib.mapAttrs'
      (name: config: nixpkgs.lib.nameValuePair name config.config.system.build.toplevel)
      self.nixosConfigurations
  ) // (nixpkgs.lib.mapAttrs'
    (name: config: nixpkgs.lib.nameValuePair name config.activation-script)
    self.hmConfigurations
  ) // (let tests = import ./tests; in flake-utils.lib.eachDefaultSystem tests);
}
