{
  tubslatex = final: prev: {
    # Based on https://gist.github.com/clefru/9ed1186bf0b76d27e0ad20cbd9966b87
    tubslatex =
      prev.lib.overrideDerivation
        (prev.texlive.combine {
          inherit (prev.texlive) scheme-full;
          tubslatex.pkgs = [ (prev.callPackage ../pkgs/tubslatex { }) ];
        })
        (oldAttrs: {
          postBuild =
            ''
              # Save the udpmap.cfg because texlive.combine removes it.
              cat $out/share/texmf/web2c/updmap.cfg > $out/share/texmf/web2c/updmap.cfg.1
            ''
            + oldAttrs.postBuild
            + ''
              # Move updmap.cfg into its original place and rerun mktexlsr, so that kpsewhich finds it
              rm $out/share/texmf/web2c/updmap.cfg || true
              cat $out/share/texmf/web2c/updmap.cfg.1 > $out/share/texmf/web2c/updmap.cfg
              rm $out/share/texmf/web2c/updmap.cfg.1
              perl `type -P mktexlsr.pl` $out/share/texmf
              yes | perl `type -P updmap.pl` --sys --syncwithtrees --force || true
              perl `type -P updmap.pl` --sys --enable Map=NexusProSerif.map --enable Map=NexusProSans.map
              # Regenerate .map files.
              perl `type -P updmap.pl` --sys
            '';
        });
  };

  kanboard = final: prev: {
    kanboard = prev.kanboard.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        owner = "kanboard";
        repo = "kanboard";
        rev = "v${oldAttrs.version}";
        sha256 = "sha256-WG2lTPpRG9KQpRdb+cS7CqF4ZDV7JZ8XtNqAI6eVzm0=";
      };
    });
  };

  soft-serve = final: prev: {
    soft-serve = prev.callPackage ./pkgs/soft-serve.nix { };
  };

  map = final: prev: {
    map = prev.callPackage ./pkgs/map.nix { };
  };
}
