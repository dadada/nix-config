{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  src = fetchzip {
    url = https://gitlab.ibr.cs.tu-bs.de/tubslatex/tubslatex/-/jobs/116760/artifacts/raw/builds/tubslatex.tds.zip;
    sha256 = "0vvgwwkd8y7nk1lkda6zsnfnzmvgda1g59yawsknmw246y8nw8ln";
    stripRoot = false;
  };
  installPhase = ''
      mkdir -p $out
      cp -r * $out/
  '';
  pname = "tubslatex";
  name = pname;
  tlType = "run";
}
