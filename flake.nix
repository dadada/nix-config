{
  description = "dadada's nix flake";

  inputs = {
    myNixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    emacs-overlay = {
      url = github:nix-community/emacs-overlay;
      inputs.nixpkgs.follows = "myNixpkgs";
    };
    flake-utils.url = github:numtide/flake-utils;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "myNixpkgs";
    };
    nix-doom-emacs = {
      url = github:vlaci/nix-doom-emacs/develop;
      inputs.emacs-overlay.follows = "emacs-overlay";
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
      flake = false;
      url = github:dadada/dadada.li;
    };
  };

  outputs = { ... } @ args: import ./outputs.nix args;
}
