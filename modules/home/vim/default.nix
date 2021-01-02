{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dadada.home.vim;
  vimPlugins = pkgs.callPackage ../../../pkgs/vimPlugins { };
in
{
  options.dadada.home.vim = {
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
        vimPlugins.spacemacsTheme
        vimPlugins.filetype
        #pkgs.vimPlugins.vim-gnupg
        #pkgs.vimPlugins.vim-l9
        pkgs.vimPlugins.vim-ledger
        #pkgs.vimPlugins.clang_complete
      ];
    };
    home.packages = with pkgs; [
      languagetool
      nixpkgs-fmt
    ];
  };
}
