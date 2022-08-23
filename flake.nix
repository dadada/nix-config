{
  description = "dadada's nix flake";

  inputs = {
    myNixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    flake-utils.url = github:numtide/flake-utils;
    home-manager = {
      url = github:nix-community/home-manager/release-22.05;
      inputs.nixpkgs.follows = "myNixpkgs";
    };
    nix-doom-emacs = {
      url = github:nix-community/nix-doom-emacs;
      inputs.nixpkgs.follows = "myNixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    nixpkgs.follows = "myNixpkgs";
    nvd = {
      url = git+https://gitlab.com/khumba/nvd.git;
      inputs.nixpkgs.follows = "myNixpkgs";
    };
    scripts = {
      url = git+https://git.dadada.li/dadada/scripts.git?ref=main;
      inputs.nixpkgs.follows = "myNixpkgs";
    };
    homePage = {
      url = github:dadada/dadada.li;
    };
    recipemd = {
      url = github:dadada/recipemd/nix-flake;
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "myNixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "myNixpkgs";
    };
  };

  outputs = { ... } @ args: import ./outputs.nix args;
}
