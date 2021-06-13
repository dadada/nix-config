{
  description = "dadada's nix flake";

  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager.url = github:nix-community/home-manager;
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
  };

  outputs = { ... } @ args: import ./outputs.nix args;
}
