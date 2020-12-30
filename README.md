# nix configuration

```nix
{
  imports = [
    ./modules/profiles/gorgon.nix
    ./private/metis
  ];
}
```

```nix
{ config, pkgs, lib, ... }:

let
  dadada = builtins.fetchGit {
    url = "/home/dadada/nix-config.git";
    ref = "main";
    rev = "4337055f4512c390b99d631e7ed1db0282e82d17";
  } {};
in {
  imports = [
    ./hardware-configuration.nix
    dadada.hosts.gorgon
  ];

  system.stateVersion = "20.03";
}
```
