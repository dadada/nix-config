self: super: {
  python3Packages =
    super.python3Packages
    // super.recurseIntoAttrs (
      super.python3Packages.callPackage ../pkgs/python-pkgs {}
    );
}
