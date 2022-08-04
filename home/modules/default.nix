{ self
, nix-doom-emacs
, ...
} @ inputs: {
  alacritty = import ./alacritty;
  colors = import ./colors.nix;
  direnv = import ./direnv.nix;
  emacs = import ./emacs { inherit nix-doom-emacs; };
  fish = import ./fish.nix;
  git = import ./git.nix;
  gpg = import ./gpg.nix;
  gtk = import ./gtk.nix;
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
