{
  pkgs,
  stdenv,
  lib,
}: (import
  (pkgs.fetchgit {
    url = "https://git.dadada.li/dadada/scripts.git";
    sha256 = "sha256-Kdwb34XXLOl4AaiVmOZ3nlu/KdENMqvH+UwISv8Pyiw=";
    rev = "065ff0f0ee9e44234678f0fefbba7961ea42518c";
  })
  {
    stdenv = stdenv;
    lib = lib;
  })
