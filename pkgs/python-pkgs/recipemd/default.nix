{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonPackages
, isPy36
, isPy27
}:

buildPythonPackage rec {
  pname = "recipemd";
  version = "4.0.5";

  disabled = isPy36 || isPy27;

  src = fetchFromGitHub {
    owner = "tstehr";
    repo = "RecipeMD";
    rev = "v${version}";
    sha256 = "17ph5gnbrx6159cryjlpkkp15gvazvxgm6ixcmrbdmsg6rgyqcpn";
  };

  patchPhase = ''
    sed -i 's/argcomplete~=1.10.0/yarl~=1.0/' setup.py
    sed -i 's/yarl~=1.3.0/yarl~=1.0/' setup.py
  '';

  propagatedBuildInputs = with pythonPackages; [
    CommonMark
    argcomplete
    dataclasses-json
    pyparsing
    yarl
  ];

  checkInputs = [
    pytestCheckHook
    pythonPackages.pytestcov
  ];

  doCheck = true;

  meta = with lib; {
    description = "Markdown recipe manager, reference implementation of RecipeMD";
    homepage = https://recipemd.org;
    license = [ licenses.lgpl3Only ];
    maintainers = [ maintainers.dadada ];
  };
}
