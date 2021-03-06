{ ... }@inputs:
{
  admin = import ./admin.nix;
  backup = import ./backup.nix;
  element = import ./element.nix;
  fido2 = import ./fido2.nix;
  fileShare = import ./fileShare.nix;
  gitea = import ./gitea.nix;
  headphones = import ./headphones.nix;
  homepage = import ./homepage.nix;
  networking = import ./networking.nix;
  share = import ./share.nix;
  steam = import ./steam.nix;
  update = import ./update.nix;
  vpnServer = import ./vpnServer.nix;
  weechat = import ./weechat.nix;
}
