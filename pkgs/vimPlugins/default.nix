{ pkgs, lib, fetchFromGitHub, ... }:
with lib;
{
  filetype = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "dadadaVimFiletype";
    version = "0.2";
    src = ./filetype;
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

  vim-buftabline = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "vim-buftabline";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "ap";
      repo = "vim-buftabline";
      rev = "73b9ef5dcb6cdf6488bc88adb382f20bc3e3262a";
      sha256 = "1vs4km7fb3di02p0771x42y2bsn1hi4q6iwlbrj0imacd9affv5y";
    };
  };
}
