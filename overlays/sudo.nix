self: super:
{
  sudo = super.sudo.overrideAttrs (old: rec {
    pname = "sudo";
    version = "1.9.5p2";
    src = self.fetchurl {
      url = "https://www.sudo.ws/dist/${pname}-${version}.tar.gz";
      sha256 = "0y093z4f3822rc88g9asdch12nljdamp817vjxk04mca7ks2x7jk";
    };
  });
}
