# Borrowed from nixpkgs.
# See https://github.com/NixOS/nixpkgs/issues/86349
{ lib, buildGoModule, fetchFromGitHub, makeWrapper, git, bash }:

buildGoModule rec {
  pname = "soft-serve";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    rev = "v${version}";
    sha256 = "sha256-PY/BHfuDRHXpzyUawzZhDr1m0c1tWqawW7GP9muhYAs=";
  };

  vendorHash = "sha256-jtEiikjEOThTSrd+UIEInxQmt2z5YVyksuTC17VmdkA=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/soft \
      --prefix PATH : "${lib.makeBinPath [ git bash ]}"
  '';

  meta = with lib; {
    description = "A tasty, self-hosted Git server for the command line";
    homepage = "https://github.com/charmbracelet/soft-serve";
    changelog = "https://github.com/charmbracelet/soft-serve/releases/tag/v${version}";
    mainProgram = "soft";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
