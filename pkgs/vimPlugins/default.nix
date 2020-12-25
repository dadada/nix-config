{ pkgs, lib, fetchFromGitHub, ... }:
with lib;
{
  filetype = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "dadadaVimFiletype";
    version = "2010-11-06";
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
}
