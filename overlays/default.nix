{
  tubslatex = import ./tubslatex.nix;
  dadadaKeys = self: super: {
    dadadaKeys = super.callPackage ../pkgs/keys { };
  };
  homePage = self: super: {
    homePage = super.callPackage ../pkgs/homePage { };
  };
  dadadaScripts = self: super: {
    dadadaScripts = super.callPackage ../pkgs/scripts.nix { };
  };
  python3Packages = import ./python3-packages.nix;
  recipemd = self: super: {
    recipemd = super.python3Packages.toPythonApplication super.python3Packages.recipemd;
  };
}
