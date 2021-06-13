{ mkShell
, deploy
}:

mkShell {
  buildInputs = [
    deploy
  ];
}
