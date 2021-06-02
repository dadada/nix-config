{ lib 
, git
, openssh
, bash
}:
with lib;
mkDerivation rec {
  name = "dadada-deploy";
  version = "0.1";

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
  meta = {
    description = "deploy scripts";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = [ "dadada" ];
  };
}
