{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.dadada.home.git;
in
{
  options.dadada.home.git = {
    enable = mkEnableOption "Enable git config";
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      extraConfig = {
        core = {
          whitespace = {
            tab-in-indent = true;
            tabwidth = 4;
          };
          alias = {

          };
          pager = "delta";
        };
        column = {
          ui = "never";
        };
        checkout = {
          defaultRemote = "origin";
        };
        delta = {
          navigate = true; # use n and N to move between diff sections
        };
        diff = {
          renames = "copies";
          algorithm = "histogram";
          colorMoved = "default";
        };
        interactive = {
          diffFilter = "delta --color-only";
        };
        merge = {
          conflictstyle = "diff3";
        };
        status = {
          short = true;
          branch = true;
          showUntrackedFiled = "all";
        };
        commit = {
          verbose = true;
        };
        log = {
          date = "iso8601-local";
        };
        pull = {
          prune = true;
        };
      };
    };

    home.packages = with pkgs; [
      delta
      git-lfs
      gitAndTools.hub
      gitAndTools.lab
      gitAndTools.git-absorb
    ];
  };
}
