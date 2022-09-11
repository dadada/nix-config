{ pkgs
, deploy-rs
, system
, ...
}:
{
  nixos-switch = {
    type = "app";
    program = toString (pkgs.writeScript "nixos-switch" ''
      #!${pkgs.runtimeShell}
      flake=$(nix flake metadata --json ${./.} | jq -r .url)
      ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ".#$1" --use-remote-sudo
    '');
  };

  deploy = {
    type = "app";
    program = toString (pkgs.writeScript "deploy" ''
      #!${pkgs.runtimeShell}
      flake=$(nix flake metadata --json ${./.} | jq -r .url)
      ${deploy-rs.apps."${system}".deploy-rs.program} ''${flake}
    '');
  };

  update = {
    type = "app";
    program = toString (pkgs.writeScript "update" ''
      #!${pkgs.runtimeShell}
      ${pkgs.nix}/bin/nix flake update --commit-lock-file
    '');
  };
}

