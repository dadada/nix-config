{ pkgs, ... }:
{
  nixos-switch = {
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
  hm-switch = {
    type = "app";
    program = toString (pkgs.writeScript "hm-switch" ''
      #!${pkgs.runtimeShell}
      set -eu -o pipefail -x
      tmpdir=$(mktemp -d)
      export PATH=${pkgs.lib.makeBinPath [pkgs.coreutils pkgs.nixFlakes pkgs.jq]}
      trap "rm -rf $tmpdir" EXIT
      declare -A profiles=(["gorgon"]="home")
      profile=''${profiles[$HOSTNAME]:-common}
      flake=$(nix flake metadata --json ${./.} | jq -r .url)
      nix build --out-link "$tmpdir/result" "$flake#hmConfigurations.''${profile}.activationPackage" "$@"
      link=$(realpath $tmpdir/result)
      $link/activate
    '');
  };
}

