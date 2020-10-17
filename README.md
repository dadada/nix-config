# nixpkgs configuration

This repository contains nix modules, overlays and packages for my home and work setups.

It requires [home-manager](https://github.com/nix-community/home-manager) to be set up and available in your path. Private parts of the configuration are not part of the repo. I include them from `home.nix` like so:

```nix
{
  imports = [
    ./modules/profiles/gorgon.nix
    ./private/metis
  ];
}
```
