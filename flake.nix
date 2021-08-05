{
  description = "dadada's nix flake";

  inputs = {
    myNixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    emacs-overlay = {
      url = github:nix-community/emacs-overlay;
      inputs.nixpkgs.follows = "myNixpkgs";
    };
    flake-utils.url = github:numtide/flake-utils;
    unstableNixpkgs.url = "github:nixos/nixpkgs?rev=c464dc811babfe316ed4ab7bbc12351122e69dd7";
    home-manager = {
      url = github:nix-community/home-manager;
      # broken some commit after c464dc811babfe316ed4ab7bbc12351122e69dd7
      #inputs.nixpkgs.follows = "unstableNixpkgs";
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
  };

  outputs = { ... } @ args: import ./outputs.nix args;
}
