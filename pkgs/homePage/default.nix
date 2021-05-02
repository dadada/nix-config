{ stdenv, pandoc, fetchFromGitHub }:
stdenv.mkDerivation rec {
  src = fetchFromGitHub {
    owner = "dadada";
    repo = "dadada.li";
    rev = "9dcb016b71abefe5546bc118a618bba87295a859";
    sha256 = "0k74kkrvbkxi129ch6yqr1gfmlxpb4661gh9hqhx8w6babsw2zg5";
  };
  nativeBuildInputs = [ pandoc ];
  buildPhase = ''
    ./build.sh
  '';
  installPhase = ''
    mkdir -p $out
    cp -r src/* $out/
  '';
  name = "dadada.li";
  version = "0.1";
}
