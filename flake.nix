{
  description = "dadada's nix flake";

  inputs = {
    emacs-overlay = {
      url = github:nix-community/emacs-overlay;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = github:numtide/flake-utils;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs = {
      url = github:vlaci/nix-doom-emacs;
      inputs.emacs-overlay.follows = "emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nvd = {
      url = git+https://gitlab.com/dadada_/nvd.git?ref=init-flake;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { ... } @ args: import ./outputs.nix args;
}
