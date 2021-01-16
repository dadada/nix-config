# nix configuration

Use at your own risk.

## Deploying

The `./deploy` script generates a NixOS configuration that pins the current git `HEAD` of this project and copies the resulting `configuration.nix` to the destionation host. Then it tests the new confiurations and rolls back if it fails.

## TODO

- Use `nix-copy-closure`?
