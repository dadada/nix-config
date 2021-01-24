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
}
