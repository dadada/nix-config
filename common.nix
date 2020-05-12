{ config, pkgs, ... }:
{
  imports = [
    ./vim
    ./tmux.nix
    ./zsh.nix
    (import ./termite.nix {
      config = config;
      pkgs = pkgs;
      colors = import ./colors.nix;
    })
    ./gpg.nix
    ./ssh.nix
    ./git.nix
    ./gtk.nix
    ./xdg.nix
  ];

  systemd.user.services = {
    auto-source-volume = {
      Unit = {
        Description = "Revert setting volume of microphone";
        Documentation = [ "man(1)pacmd" ];
        BindsTo = "pulseaudio.service";
      };

      Service = {
        ExecStart = "/bin/sh %h/bin/auto-source-volume.sh";
        Type = "simple";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
