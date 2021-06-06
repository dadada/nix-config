{ stdenv, pandoc, fetchFromGitHub }:
stdenv.mkDerivation rec {
  src = fetchFromGitHub {
    owner = "dadada";
    repo = "dadada.li";
    rev = "39db7ded7ddc8a3b8de079d6dd7d97b1afa366a7";
    sha256 = "1d3vz1h66n8dka90br10niiv8n5blpbfqgcv98dh8y6880sm1fd7";
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
