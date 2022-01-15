{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dadada.home.zsh;
in
{
  options.dadada.home.zsh = {
    enable = mkEnableOption "Enable ZSH config";
  };
  config = mkIf cfg.enable {
    programs.fzf.enableZshIntegration = true;
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autocd = true;
      sessionVariables = {
        EDITOR = "vim";
      };
      history = {
        extended = true;
        ignoreDups = true;
        ignoreSpace = true;
        save = 100000;
        share = true;
      };
      plugins = [
      ];
      initExtra = ''
        source ${pkgs.zsh-git-prompt}/share/zsh-git-prompt/zshrc.sh
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        source ${pkgs.fzf}/share/fzf/completion.zsh

        bindkey '^n' autosuggest-accept

        preexec() { echo -n -e "\033]0;$1\007" }

        PROMPT="%F{red}%?%f %F{green}%m%f:%F{blue}%~%f "
        RPROMPT='$(git_super_status)'
        #NIX_BUILD_SHELL="${pkgs.zsh}/bin/zsh"
      '';
      profileExtra = ''
      '';
      shellAliases = {
        ga = "git add";
        gc = "git commit";
        gd = "git diff";
        gf = "git fetch";
        gl = "git log";
        gpu = "git push";
        gpul = "git pull";
        grb = "git rebase";
        gre = "git reflog";
        gs = "git status";
        gsh = "git show";
        gst = "git status";
        gsta = "git stash";
        gstap = "git stash apply";
        ls = "exa";
        la = "exa -a";
        ll = "exa -la --no-filesize --changed --time-style=long-iso --git  --octal-permissions --no-permissions --no-user --ignore-glob=\".git\"";
        mv = "mv -i";
        cp = "cp -i";
      };
    };

    home.packages = with pkgs; [
      fzf
      exa
      zsh-git-prompt
      tmux
    ];
  };
}
