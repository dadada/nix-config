{ lib }:

with lib;
mkDerivation rec {
  name = "dadadaKeys";
  version = "1";

  src = ./keys;

  buildPhase = "";

  installPhase = ''
    mkdir $out
    cp * $out
  '';

  meta = {
    description = "Public keys for my infrastructure";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ "dadada" ];
  };
}
