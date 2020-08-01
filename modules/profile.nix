{ config, pkgs, lib, ... }:
{
  programs.bash = {
    enable = true;
    profileExtra = ''
        export TERM="xterm-256color"
        export EDITOR="vim"
        alias gst="git status"
        alias gco="git commit";
        alias glo="git log";
        alias gad="git add";
        alias ls="exa";
        alias ll="exa -l";
        alias la="exa -la";
        alias mv="mv -i";
        alias cp="cp -i";
    '';
  };

  home.packages = [
    pkgs.exa
    pkgs.fzf
  ];

}
