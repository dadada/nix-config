{ stdenv
, lib
, git
, openssh
, bash
}:
stdenv.mkDerivation rec {
  name = "dadada-deploy";
  version = "0.1.1";

  src = ../utils;

  buildInputs = [
    git
    openssh
    bash
  ];

  installPhase = ''
    mkdir -p $out/bin
    for script in \
      deploy \
      gen-config
    do
      install $script $out/bin/
    done
  '';
  meta = with lib; {
    description = "deploy scripts";
    license = licenses.publicDomain;
    platforms = platforms.unix;
    maintainers = [ "dadada" ];
  };
}
