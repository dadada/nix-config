{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonPackages
, isPy36
, isPy27
}:

buildPythonPackage rec {
  pname = "recipemd";
  version = "4.0.6";

  disabled = isPy36 || isPy27;

  src = fetchPypi {
    pname = pname;
    version = version;
    sha256 = "05c185bhrc72a9c3gvjy50npwn6cqml69slis2v4waqj31snps33";
  };

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
