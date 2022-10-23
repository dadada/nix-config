{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "map";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "soveran";
    repo = pname;
    rev = "0.1.1";
    sha256 = "sha256-yGzmhZwv1qKy0JNcSzqL996APQO8OGWQ1GBkEkKTOXA=";
  };

  makefile = "makefile";

  installPhase = ''
    export PREFIX="$out";
    mkdir -p "$out"
    make install
  '';

  checkPhase = ''
    make test
  '';

  meta = with lib; {
    description = "Map lines from stdin to commands";
    license = licenses.bsd2;
    homepage = "https://github.com/soveran/map";
    platforms = platforms.all;
    maintainers = with maintainers; [ dadada ];
  };
}
