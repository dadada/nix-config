{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.dadada.admin;
in
{
  options = {
    dadada.admin = {
      enable = mkEnableOption "Enable admin access";

      users = mkOption {
        type = with types; attrsOf (listOf path);
        default = [ ];
        description = ''
          List of admin users with root access to all the machine.
        '';
        example = literalExample "\"user1\" = [ /path/to/key1 /path/to/key2 ]";
      };

      rat = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable NAT and firewall traversal for SSH via tor hidden service
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.sshd.enable = true;
    services.openssh.passwordAuthentication = false;
    security.sudo.wheelNeedsPassword = false;

    users.users = mapAttrs
      (user: keys: (
        {
          extraGroups = [
            "wheel"
            "libvirtd"
          ];
          isNormalUser = true;
          openssh.authorizedKeys.keyFiles = keys;
        }))
      cfg.users;

    nix.trustedUsers = builtins.attrNames cfg.users;

    users.mutableUsers = mkDefault false;

    networking.firewall.allowedTCPPorts = [ 22 ];

    environment.systemPackages = with pkgs; [
      vim
      tmux
    ];

    services.tor.relay.onionServices = {
      "rat" = mkIf cfg.rat.enable {
        name = "rat";
        map = [{ port = 22; }];
      };
    };
  };
}
