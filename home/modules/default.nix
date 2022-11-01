{
  alacritty = import ./alacritty;
  colors = import ./colors.nix;
  direnv = import ./direnv.nix;

  # Disable because can't get importing the module to work
  #emacs = import ./emacs;

  fish = import ./fish.nix;
  git = import ./git.nix;
  gpg = import ./gpg.nix;
  gtk = import ./gtk.nix;
  helix = import ./helix;
  keyring = import ./keyring.nix;
  kitty = import ./kitty;
  mako = import ./mako.nix;
  session = import ./session.nix;
  ssh = import ./ssh.nix;
  sway = import ./sway;
  syncthing = import ./syncthing.nix;
  termite = import ./termite.nix;
  tmux = import ./tmux.nix;
  vim = import ./vim;
  xdg = import ./xdg.nix;
  zsh = import ./zsh.nix;
}
