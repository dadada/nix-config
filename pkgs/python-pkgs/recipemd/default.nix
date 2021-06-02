{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonPackages
, installShellFiles
, isPy36
, isPy27
}:

buildPythonPackage rec {
  pname = "recipemd";
  version = "4.0.7";

  disabled = isPy36 || isPy27;

  src = fetchPypi {
    pname = pname;
    version = version;
    sha256 = "142w5zb2gf8s5z72bflpkmks633ic42z97nsgw491mskl6jg7cvq";
  };

  propagatedBuildInputs = with pythonPackages; [
    CommonMark
    argcomplete
    dataclasses-json
    pyparsing
    yarl
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    ${pythonPackages.argcomplete}/bin/register-python-argcomplete -s bash ${pname} > $out/completions.bash
    installShellCompletion --bash --name recipemd.bash $out/completions.bash

    ${pythonPackages.argcomplete}/bin/register-python-argcomplete -s fish ${pname} > $out/completions.fish
    installShellCompletion --fish --name recipemd.fish $out/completions.fish

    # The version of argcomplete in nixpkgs-stable does not have support for zsh
    #${pythonPackages.argcomplete}/bin/register-python-argcomplete -s zsh ${pname} > $out/completions.zsh
    #installShellCompletion --zsh --name _recipemd $out/completions.zsh
  '';

  checkInputs = [
    pytestCheckHook
    pythonPackages.pytestcov
  ];

  doCheck = false;

  meta = with lib; {
    description = "Markdown recipe manager, reference implementation of RecipeMD";
    homepage = https://recipemd.org;
    license = [ licenses.lgpl3Only ];
    maintainers = [ maintainers.dadada ];
  };
}
