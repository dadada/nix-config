{...} @ inputs: {
  admin = import ./admin.nix;
  backup = import ./backup.nix;
  ddns = import ./ddns.nix;
  element = import ./element.nix;
  fido2 = import ./fido2.nix;
  fileShare = import ./fileShare.nix;
  gitea = import ./gitea.nix;
  headphones = import ./headphones.nix;
  homepage = import ./homepage.nix;
  kanboard = import ./kanboard;
  networking = import ./networking.nix;
  nix = import ./nix.nix inputs;
  share = import ./share.nix;
  steam = import ./steam.nix;
  update = import ./update.nix;
  vpnServer = import ./vpnServer.nix;
  weechat = import ./weechat.nix;
}
