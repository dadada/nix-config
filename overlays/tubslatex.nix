self: super:
{
  # Based on https://gist.github.com/clefru/9ed1186bf0b76d27e0ad20cbd9966b87
  tubslatex = super.lib.overrideDerivation (super.texlive.combine {
    inherit (super.texlive) scheme-full;
    tubslatex.pkgs = [ (super.callPackage ../pkgs/tubslatex {}) ];
  }) (oldAttrs: {
    postBuild = ''
       # Save the udpmap.cfg because texlive.combine removes it.
       cat $out/share/texmf/web2c/updmap.cfg > $out/share/texmf/web2c/updmap.cfg.1
       '' + oldAttrs.postBuild + ''
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

}

