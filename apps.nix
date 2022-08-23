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

  deploy = {
    type = "app";
    program = toString (pkgs.writeScript "self-deploy" ''
      #!${pkgs.runtimeShell}
      flake=$(nix flake metadata --json ${./.} | jq -r .url)
      deploy ''${flake}
    '');
  };
}

