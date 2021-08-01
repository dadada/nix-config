let
  python3Packages = import ./python3-packages.nix;
in
{
  #tubslatex = import ./tubslatex.nix;
  keys = final: prev: {
    keys = prev.callPackage ../pkgs/keys { };
  };
  homePage = final: prev: {
    homePage = prev.callPackage ../pkgs/homePage { };
  };
  recipemd = final: prev: {
    recipemd = prev.python3Packages.toPythonApplication prev.python3Packages.recipemd;
  };
}
