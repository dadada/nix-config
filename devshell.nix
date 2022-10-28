{ pkgs, extraModules, ... }:
(pkgs.devshell.mkShell {
  imports = extraModules;

  name = "dadada/nix-config";

  packages = with pkgs; [
    agenix
    nixpkgs-fmt
    nixos-rebuild
  ];

  commands = [
    {
      name = "switch";
      help = "Switch the configuration on the current system.";
      command = ''
        flake=$(nix flake metadata --json ${./.} | jq -r .url)
        ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ".#" --use-remote-sudo
      '';
      category = "deploy";
    }
    {
      name = "format";
      help = "Format the project";
      command = ''
        nixpkgs-fmt .
      '';
      category = "dev";
    }
    {
      name = "update";
      help = "Update the project";
      command = ''
        nix flake update --commit-lock-file
      '';
      category = "dev";
    }
    {
      name = "deploy";
      help = "Deploy this flake";
      package = "deploy-rs";
      category = "deploy";
    }
    {
      name = "check";
      help = "Run checks";
      category = "dev";
      command = "nix flake check";
    }
  ];

  git.hooks = {
    pre-push.text = "nix flake check";
  };
})
