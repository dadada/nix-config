{ stdenv, pandoc, fetchFromGitHub }:
stdenv.mkDerivation rec {
  src = fetchFromGitHub {
    owner = "dadada";
    repo = "dadada.li";
    rev = "9dcb016b71abefe5546bc118a618bba87295a859";
    sha256 = "1d3vz1h66n8dka90br10niiv8n5blpbfqgcvx8dh8y6880sm1fd7";
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
  version = "0.2";
}
