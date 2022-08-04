{
  stdenv,
  fetchzip,
  unzip,
}:
stdenv.mkDerivation rec {
  src = ./tubslatex_1.3.2.tds.zip;
  sourceRoot = ".";
  nativeBuildInputs = [unzip];
  buildInputs = [unzip];
  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';
  pname = "tubslatex";
  name = pname;
  tlType = "run";
}
