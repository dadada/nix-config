{ config, pkgs, lib, ... }:
{
  programs.fzf.enableZshIntegration = true;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    sessionVariables = {
      TERM = "xterm-256color";
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
       source ~/.nix-profile/share/zsh-git-prompt/zshrc.sh
       source ~/.nix-profile/share/fzf/key-bindings.zsh
       source ~/.nix-profile/share/fzf/completion.zsh

       preexec() { echo -n -e "\033]0;$1\007" }

       PROMPT="%F{red}%?%f %F{green}%m%f:%F{blue}%~%f "
       RPROMPT='$(git_super_status)'
       #NIX_BUILD_SHELL="${pkgs.zsh}/bin/zsh"
    '';
    profileExtra = ''
      '';
    shellAliases = {
      gst = "git status";
      gco = "git commit";
      glo = "git log";
      gad = "git add";
      ls = "exa";
      ll = "exa -l";
      la = "exa -la";
      mv = "mv -i";
      cp = "cp -i";
    };
  };

  home.packages = [
    pkgs.exa
    pkgs.zsh-git-prompt
  ];

}
