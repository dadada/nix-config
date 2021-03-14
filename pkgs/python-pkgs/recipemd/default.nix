{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, python3Packages
}:

buildPythonPackage rec {
  pname = "recipemd";
  version = "4.0.5";

  disabled = false; # requires python version >=3.7,<4

  src = fetchFromGitHub {
    owner = "tstehr";
    repo = "RecipeMD";
    rev = "v${version}";
    sha256 = "17ph5gnbrx6159cryjlpkkp15gvazvxgm6ixcmrbdmsg6rgyqcpn";
  };

  # # Package conditions to handle
  # # might have to sed setup.py and egg.info in patchPhase
  # # sed -i "s/<package>.../<package>/"
  # # Extra packages (may not be necessary)
  # pytest-cov==2.8.1 # tests
  # tox==3.20.1 # tests
  # Sphinx==2.2.2 # docs
  # m2r==0.2.1 # docs
  # sphinxcontrib.fulltoc==1.2.0 # docs
  # sphinxcontrib.autoprogram==0.1.5 # docs
  # sphinx_autodoc_typehints==1.10.3 # docs
  # sphinxcontrib.apidoc==0.3.0 # docs
  # sphinx-autobuild==0.7.1 # docs
  # twine==3.1.1 # release
  # pytest==5.3.1 # dev
  # pytest-cov==2.8.1 # dev
  # tox==3.20.1 # dev
  # Sphinx==2.2.2 # dev
  # m2r==0.2.1 # dev
  # sphinxcontrib.fulltoc==1.2.0 # dev
  # sphinxcontrib.autoprogram==0.1.5 # dev
  # sphinx_autodoc_typehints==1.10.3 # dev
  # sphinxcontrib.apidoc==0.3.0 # dev
  # sphinx-autobuild==0.7.1 # dev
  # twine==3.1.1 # dev

  patchPhase = ''
    # Override yarl version
    sed -i 's/argcomplete~=1.10.0/yarl~=1.0/' setup.py
    sed -i 's/yarl~=1.3.0/yarl~=1.0/' setup.py
  '';

  propagatedBuildInputs = with python3Packages; [
    dataclasses-json
    yarl
    CommonMark
    argcomplete
    pyparsing
  ];

  checkInputs = [
    pytestCheckHook
    python3Packages.pytestcov
  ];

  doCheck = true;

  meta = with lib; {
    description = "Markdown recipe manager, reference implementation of RecipeMD";
    homepage = https://recipemd.org;
    license = [ licenses.lgpl3Only ];
    maintainers = [ maintainers.dadada ];
  };
}
