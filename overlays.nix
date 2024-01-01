{
  kanboard = final: prev: {
    kanboard = prev.kanboard.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        owner = "kanboard";
        repo = "kanboard";
        rev = "v${oldAttrs.version}";
        sha256 = "sha256-WG2lTPpRG9KQpRdb+cS7CqF4ZDV7JZ8XtNqAI6eVzm0=";
      };
    });
  };

  recipemd = final: prev: {
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (
        python-final: python-prev: {
          recipemd = python-final.callPackage ./pkgs/recipemd.nix { };
        }
      )
    ];
    recipemd = prev.python3Packages.toPythonApplication final.python3Packages.recipemd;
  };
}
