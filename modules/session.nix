{ config, sessionVars }:
{
  home.sessionVariables = sessionVars;
  systemd.user.sessionVariables = sessionVars;
}
