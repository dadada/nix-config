let
  python3Packages = import ./python3-packages.nix;
in
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
}
