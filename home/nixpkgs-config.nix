{ pkgs }:
{
  allowUnfree = true;
  allowUnfreePredicate = (pkg: true);
  allowBroken = false;
  android_sdk.accept_license = true;
}
