{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonPackages
, installShellFiles
, pythonOlder
, pythonAtLeast
}:
buildPythonPackage rec {
  pname = "recipemd";
  version = "4.0.8";

  disabled = pythonOlder "3.7" || pythonAtLeast "4";

  src = fetchFromGitHub {
    owner = "tstehr";
    repo = "RecipeMD";
    rev = "v${version}";
    hash = "sha256-eumV2zm7TIJcTPRtWSckYz7jiyH3Ek4nIAVtuJs3sJc=";
  };

  propagatedBuildInputs = with pythonPackages; [
    dataclasses-json
    yarl
    CommonMark
    argcomplete
    pyparsing
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

  doCheck = true;

  meta = with lib; {
    description = "Markdown recipe manager, reference implementation of RecipeMD";
    homepage = "https://recipemd.org";
    license = [ licenses.lgpl3Only ];
    maintainers = [ maintainers.dadada ];
  };
}
