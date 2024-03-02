{
  alacritty = import ./alacritty;
  colors = import ./colors.nix;
  direnv = import ./direnv.nix;
  git = import ./git.nix;
  gpg = import ./gpg.nix;
  gtk = import ./gtk.nix;
  helix = import ./helix;
  keyring = import ./keyring.nix;
  session = import ./session.nix;
  ssh = import ./ssh.nix;
  syncthing = import ./syncthing.nix;
  tmux = import ./tmux.nix;
  xdg = import ./xdg.nix;
  zsh = import ./zsh.nix;
}
