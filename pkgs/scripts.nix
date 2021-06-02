{ pkgs, stdenv, lib }:

(import
  (pkgs.fetchgit {
    url = "https://git.dadada.li/dadada/scripts.git";
    sha256 = "0pspybphfqmccl9w97dr89g47dbxk8ly05x8x7c313a5i3pzd5lm";
    rev = "e1a887a658da130c2a513d4c770d5026565c4e69";
  })
  { stdenv = stdenv; lib = lib; })
