{ config, pkgs, lib, fetchFromGitHub, ... }:
let 
  myFtplugins = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "myFtplugins";
    version = "2010-11-06";
    src = vim/plugins/myFtplugins;
  };
in
{
  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./vimrc;
    plugins = [
      pkgs.vimPlugins.vim-nix
      #pkgs.vimPlugins.kotlin-vim
      pkgs.vimPlugins.ale
      pkgs.vimPlugins.fzf-vim
      pkgs.vimPlugins.rust-vim
      pkgs.vimPlugins.base16-vim
      pkgs.vimPlugins.typescript-vim
      pkgs.vimPlugins.vim-airline
      pkgs.vimPlugins.vim-airline-themes
      pkgs.vimPlugins.vim-fish
      #pkgs.vimPlugins.vim-gnupg
      #pkgs.vimPlugins.vim-l9
      pkgs.vimPlugins.vim-ledger
    ];
  };
}

