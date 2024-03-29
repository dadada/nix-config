{
  admin = import ./admin.nix;
  backup = import ./backup.nix;
  borgServer = import ./borg-server.nix;
  ddns = import ./ddns.nix;
  element = import ./element.nix;
  fileShare = import ./fileShare.nix;
  gitea = import ./gitea.nix;
  headphones = import ./headphones.nix;
  homepage = import ./homepage.nix;
  miniflux = import ./miniflux.nix;
  inputs = import ./inputs.nix;
  nixpkgs = import ./nixpkgs.nix;
  packages = import ./packages.nix;
  secrets = import ./secrets.nix;
  share = import ./share.nix;
  steam = import ./steam.nix;
  sway = import ./sway.nix;
  vpnServer = import ./vpnServer.nix;
  weechat = import ./weechat.nix;
  yubikey = import ./yubikey.nix;
}
