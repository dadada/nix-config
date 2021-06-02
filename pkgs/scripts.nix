{ lib }:

(import
  (builtins.fetchGit {
    url = "https://git.dadada.li/dadada/scripts.git";
    ref = "main";
    rev = "3393073cd3511d43f622972b891a20ba069fa052";
  })
  { inherit lib; })
