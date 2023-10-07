{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.dadada.home.git;
  allowedSigners = pkgs.writeTextFile {
    name = "allowed-signers";
    text = ''
      dadada@dadada.li sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKu+pA5Vy0QPHJMjn2S5DCsqKg2UvDhOsBwvvJLf4HbyAAAABHNzaDo= dadada <dadada@dadada.li>
    '';
  };
in
{
  options.dadada.home.git = {
    enable = mkEnableOption "Enable git config";
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      extraConfig = {
        commit = {
          gpgSign = true;
          verbose = true;
        };
        gpg = {
          format = "ssh";
          ssh.allowedSignersFile = "${allowedSigners}";
        };
        tag.gpgSign = true;
        user = {
          email = "dadada@dadada.li";
          name = "dadada";
          signingKey = "key::sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKu+pA5Vy0QPHJMjn2S5DCsqKg2UvDhOsBwvvJLf4HbyAAAABHNzaDo= dadada <dadada@dadada.li>";
        };
        core = {
          whitespace = {
            tab-in-indent = true;
            tabwidth = 4;
          };
          alias = { };
          pager = "delta";
        };
        column.ui = "never";
        checkout.defaultRemote = "origin";
        delta = {
          navigate = true; # use n and N to move between diff sections
          side-by-side = false;
          line-numbers = true;
          light = false;
        };
        diff = {
          renames = "copies";
          algorithm = "histogram";
          colorMoved = "default";
        };
        interactive.diffFilter = "delta --color-only";
        merge.conflictstyle = "diff3";
        status = {
          short = true;
          branch = true;
          showUntrackedFiled = "all";
        };
        log.date = "iso8601-local";
        pull = {
          prune = true;
          ff = "only";
          rebase = "interactive";
        };
        push.default = "upstream";
        rebase.abbreviateCommands = true;
        rerere.enabled = true;
      };
    };

    home.packages = with pkgs; [
      delta
      git-branchless
      git-lfs
      gitAndTools.hub
      gitAndTools.lab
      gitAndTools.git-absorb
      meld
    ];
  };
}
