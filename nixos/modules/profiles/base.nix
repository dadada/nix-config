{ config, ... }:
{
  security.acme = {
    defaults.email = "d553a78d-0349-48db-9c20-5b27af3a1dfc@dadada.li";
    acceptTerms = true;
  };
}
