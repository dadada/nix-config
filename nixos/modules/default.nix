{
  admin = import ./admin.nix;
  backup = import ./backup.nix;
  borgServer = import ./borg-server.nix;
  ddns = import ./ddns.nix;
  element = import ./element.nix;
  fido2 = import ./fido2.nix;
  fileShare = import ./fileShare.nix;
  gitea = import ./gitea.nix;
  headphones = import ./headphones.nix;
  homepage = import ./homepage.nix;
  miniflux = import ./miniflux.nix;
  networking = import ./networking.nix;
  inputs = import ./inputs.nix;
  nixpkgs = import ./nixpkgs.nix;
  packages = import ./packages.nix;
  secrets = import ./secrets.nix;
  share = import ./share.nix;
  soft-serve = import ./soft-serve.nix;
  steam = import ./steam.nix;
  sway = import ./sway.nix;
  vpnServer = import ./vpnServer.nix;
  weechat = import ./weechat.nix;
}
