{
  description = "dadada's nix flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
    flake-utils.url = github:numtide/flake-utils;
    home-manager = {
      url = github:nix-community/home-manager/release-22.11;
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
  };

  outputs = { ... } @ args: import ./outputs.nix args;
}
