{ config
, pkgs
, lib
, ...
}:
with lib; let
  cfg = config.dadada.admin;
  extraGroups = [ "wheel" "libvirtd" ];

  shells = {
    "bash" = pkgs.bashInteractive;
    "zsh" = pkgs.zsh;
    "fish" = pkgs.fish;
  };

  shellNames = builtins.attrNames shells;

  adminOpts =
    { name
    , config
    , ...
    }: {
      options = {
        keys = mkOption {
          type = types.listOf types.str;
          default = [ ];
          apply = x: assert (builtins.length x > 0 || abort "Please specify at least one key to be able to log in"); x;
          description = ''
            The keys that should be able to access the account.
          '';
        };
        shell = mkOption {
          type = types.nullOr types.str;
          apply = x: assert (builtins.elem x shellNames || abort "Please specify one of ${builtins.toString shellNames}"); x;
          default = "zsh";
          defaultText = literalExpression "zsh";
          example = literalExpression "bash";
          description = ''
            One of ${builtins.toString shellNames}
          '';
        };
      };
    };
in
{
  options = {
    dadada.admin = {
      enable = mkEnableOption "Enable admin access";

      users = mkOption {
        type = with types; attrsOf (submodule adminOpts);
        default = import ../../admins.nix;
        description = ''
          Admin users with root access machine.
        '';
        example = literalExample "\"user1\" = { shell = pkgs.bashInteractive; keys = [ 'ssh-rsa 123456789' ]; }";
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
    assertions = [
      {
        assertion = cfg.users != [ ];
        message = "Must provide at least one admin, if the admin module is enabled.";
      }
    ];

    programs.zsh.enable = mkDefault true;

    services.sshd.enable = true;
    services.openssh.settings.PasswordAuthentication = false;
    security.sudo.wheelNeedsPassword = false;
    services.openssh.openFirewall = true;

    users.users =
      mapAttrs
        (user: keys: {
          shell = shells."${keys.shell}";
          extraGroups = extraGroups;
          isNormalUser = true;
          openssh.authorizedKeys.keys = keys.keys;
        })
        cfg.users;

    nix.settings.trusted-users = builtins.attrNames cfg.users;

    users.mutableUsers = mkDefault false;

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
