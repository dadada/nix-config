{ ... }:
{
  networking = {
    useDHCP = false;
    nat.enable = false;
    firewall.enable = false;
    nftables = {
      enable = true;
      checkRuleset = true;
      ruleset = builtins.readFile ./rules.nft;
    };
  };
}
