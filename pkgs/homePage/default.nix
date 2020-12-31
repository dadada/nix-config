{ stdenv, pandoc, fetchFromGitHub }:
stdenv.mkDerivation rec {
  src = fetchFromGitHub {
    owner = "dadada";
    repo = "dadada.li";
    rev = "9aba585da873cd40808616f76b4bf40c1d12d3f5";
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
