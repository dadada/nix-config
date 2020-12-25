{ stdenv }:

stdenv.mkDerivation rec {
  pname = "infra-keys";
  version = "1";

  src = ./keys;

  installPhase = ''
      mkdir $out
      mv * $out
  '';

  meta = with stdenv.lib; {
    description = "Public keys for my infrastructure";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ "dadada" ];
  };
}
