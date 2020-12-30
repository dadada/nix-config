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
    sha26sum = "0i8ga3d0bg4r3fdh00mfhhn6m1ck18iqjzmr9y89vjjyn430pdgf";
  } {};
in {
  imports = [
    ./hardware-configuration.nix
    dadada.hosts.gorgon
  ];

  system.stateVersion = "20.03";
}
```
