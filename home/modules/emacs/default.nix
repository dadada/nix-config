{ config
, pkgs
, lib
, ...
}:
with lib; let
  cfg = config.dadada.home.emacs;
in
{
  options.dadada.home.emacs = {
    enable = mkEnableOption "Enable dadada emacs config";
  };

  config = mkIf cfg.enable {
    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ./doom.d;
      emacsPackagesOverlay = self: super:
        with pkgs; {
          tsc = super.tsc.overrideAttrs (old:
            let
              libtsc_dyn = rustPlatform.buildRustPackage rec {
                pname = "emacs-tree-sitter";
                version = "0.15.1";
                src = fetchFromGitHub {
                  owner = "ubolonton";
                  repo = "emacs-tree-sitter";
                  rev = version;
                  sha256 = "sha256-WgkGtmw63+kRLTRiSEO4bFF2IguH5g4odCujyazkwJc=";
                };
                preBuild = ''
                  export BINDGEN_EXTRA_CLANG_ARGS="$(< ${stdenv.cc}/nix-support/libc-crt1-cflags) \
                    $(< ${stdenv.cc}/nix-support/libc-cflags) \
                    $(< ${stdenv.cc}/nix-support/cc-cflags) \
                    $(< ${stdenv.cc}/nix-support/libcxx-cxxflags) \
                    ${lib.optionalString stdenv.cc.isClang "-idirafter ${stdenv.cc.cc}/lib/clang/${lib.getVersion stdenv.cc.cc}/include"} \
                    ${lib.optionalString stdenv.cc.isGNU
                    "-isystem ${stdenv.cc.cc}/lib/gcc/${stdenv.hostPlatform.config}/${lib.getVersion stdenv.cc.cc}/include/"} \
                    ${lib.optionalString stdenv.cc.isGNU
                    "-isystem ${stdenv.cc.cc}/include/c++/${lib.getVersion stdenv.cc.cc} -isystem ${stdenv.cc.cc}/include/c++/${lib.getVersion stdenv.cc.cc}/${stdenv.hostPlatform.config}"} \
                    $NIX_CFLAGS_COMPILE"
                '';
                LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
                cargoHash = "sha256-HB5tFR1slY2D6jb2mt4KrGrGBUUVrxiBjmVycO+qfYY=";
              };
            in
            {
              inherit (libtsc_dyn) src;
              preBuild = ''
                ext=${stdenv.hostPlatform.extensions.sharedLibrary}
                dest=$out/share/emacs/site-lisp/elpa/tsc-${old.version}
                install -D ${libtsc_dyn}/lib/libtsc_dyn$ext $dest/tsc-dyn$ext
                echo -n "0.15.1" > $dest/DYN-VERSION
              '';
            });
          tree-sitter-langs = super.tree-sitter-langs.overrideAttrs (old: {
            postInstall = ''
              dest=$out/share/emacs/site-lisp/elpa/tree-sitter-langs-${old.version}
              echo -n "0.10.2" > $dest/BUNDLE-VERSION
              ${lib.concatStringsSep "\n"
                (lib.mapAttrsToList (name: src: "name=${name}; ln -s ${src}/parser $dest/bin/\${name#tree-sitter-}.so") pkgs.tree-sitter.builtGrammars)};
            '';
          });
        };
    };
    home.file.".tree-sitter".source = pkgs.runCommand "grammars" { } ''
      mkdir -p $out/bin
      echo -n "0.10.2" > $out/BUNDLE-VERSION
      ${lib.concatStringsSep "\n"
        (lib.mapAttrsToList (name: src: "name=${name}; ln -s ${src}/parser $out/bin/\${name#tree-sitter-}.so") pkgs.tree-sitter.builtGrammars)};
    '';
  };
}
