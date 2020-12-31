{ stdenv, pandoc, fetchFromGitHub }:
stdenv.mkDerivation rec {
  src = fetchFromGitHub {
    owner = "dadada";
    repo = "dadada.li";
    rev = "643916762ec242c70486aee211a43c72550ae74a";
    sha256 = "0rwzv5kp03nbi1zi5kcpdd8yabkmrj1was33dsi7ip6cbnvwn07g";
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
