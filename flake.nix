{
  description = "dadada's nix flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;
    flake-utils.url = github:numtide/flake-utils;
    home-manager = {
      url = github:nix-community/home-manager/release-23.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    homePage = {
      url = github:dadada/dadada.li;
    };
    recipemd = {
      url = github:dadada/recipemd/nix-flake;
    };
    agenix = {
      url = github:ryantm/agenix/0.13.0;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = github:numtide/devshell;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-registry = {
      url = "github:NixOS/flake-registry";
      flake = false;
    };
    helix.url = "github:helix-editor/helix/23.03";
    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { ... } @ args: import ./outputs.nix args;

  nixConfig = {
    extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs=";
    extra-substituters = "https://nix-community.cachix.org/ https://helix.cachix.org/";
    extra-trusted-substituters = "https://nix-community.cachix.org/ https://helix.cachix.org/";
  };
}
