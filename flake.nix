{
  description = "dadada's nix flake";

  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager.url = github:nix-community/home-manager;
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    nvd.url = git+https://gitlab.com/dadada_/nvd.git?ref=init-flake;
  };

  outputs = { ... } @ args: import ./outputs.nix args;
}
