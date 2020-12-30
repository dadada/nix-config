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
  dadada = import (builtins.fetchGit {
    url = "https://github.com/dadada/nix-config.git";
    sha256 = "1a661h3ssy35yha66xnhldlwlr9safzw4h83z5mg82assgbbh9fz";
  }) {};
in {
  imports = [
    ./secrets.nix
    ./hardware-configuration.nix
    dadada.hosts.ifrit
  ];

  system.stateVersion = "20.03";
}

```
