{ self, nixpkgs, flake-utils, ... }:
(nixpkgs.lib.mapAttrs'
  (name: config: nixpkgs.lib.nameValuePair name config.config.system.build.toplevel)
  self.nixosConfigurations
) //
(nixpkgs.lib.mapAttrs'
  (name: config: nixpkgs.lib.nameValuePair name config.activation-script)
  self.hmConfigurations
) //
(let tests = import ./tests; in flake-utils.lib.eachDefaultSystem tests)
