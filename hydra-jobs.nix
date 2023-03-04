{ self, nixpkgs, flake-utils, ... }:
(nixpkgs.lib.mapAttrs'
  (name: config: nixpkgs.lib.nameValuePair name config.config.system.build.toplevel)
  self.nixosConfigurations
)
