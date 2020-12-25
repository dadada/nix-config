{ config, pkgs, lib, fetchFromGitHub, ... }:
with lib;
let 
  cfg = config.dadada.vim;

  myFtplugins = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "myFtplugins";
    version = "2010-11-06";
    src = vim/plugins/myFtplugins;
  };

  spacemacsTheme = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "spacemacs-theme";
    version = "2.0.1";
    src = pkgs.fetchFromGitHub {
      owner = "colepeters";
      repo = "spacemacs-theme.vim";
      rev = "056bba9bd05a2c97c63c28216a1c232cfb91529e";
      sha256 = "0iy3i6waigk759p2z59mrxkjc0p412y7d8zf3cjak4a9sh1sh6qz";
    };
  };
in
{
  options.dadada.vim = {
    enable = mkEnableOption "Enable VIM config";
  };

  config = mkIf cfg.enable {
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
        spacemacsTheme
        #pkgs.vimPlugins.vim-gnupg
        #pkgs.vimPlugins.vim-l9
        pkgs.vimPlugins.vim-ledger
        #pkgs.vimPlugins.clang_complete
      ];
    };
    home.packages = [ pkgs.languagetool ];
  };
}
