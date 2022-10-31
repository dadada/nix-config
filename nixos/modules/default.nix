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
  kanboard = import ./kanboard;
  miniflux = import ./miniflux.nix;
  networking = import ./networking.nix;
  nix = import ./nix.nix;
  nixpkgs = import ./nixpkgs.nix;
  packages = import ./packages.nix;
  secrets = import ./secrets.nix;
  share = import ./share.nix;
  steam = import ./steam.nix;
  sway = import ./sway.nix;
  update = import ./update.nix;
  vpnServer = import ./vpnServer.nix;
  weechat = import ./weechat.nix;
}
