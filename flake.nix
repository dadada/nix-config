{
  description = "dadada's nix flake";

  inputs = {
    emacs-overlay.url = github:nix-community/emacs-overlay;
    flake-utils.url = github:numtide/flake-utils;
    home-manager.url = github:nix-community/home-manager;
    nix-doom-emacs = {
      url = github:vlaci/nix-doom-emacs;
      inputs.emacs-overlay.follows = "emacs-overlay";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nvd.url = git+https://gitlab.com/dadada_/nvd.git?ref=init-flake;
  };

  outputs = { ... } @ args: import ./outputs.nix args;
}
