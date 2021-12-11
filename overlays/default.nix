let
  python3Packages = import ./python3-packages.nix;
in
{
  #tubslatex = import ./tubslatex.nix;
  recipemd = final: prev: {
    recipemd = prev.python3Packages.toPythonApplication prev.python3Packages.recipemd;
  };
}
