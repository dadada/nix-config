{ ... }:
{
  services.chrony = {
    enable = true;
    extraConfig = ''
      allow 192.168.1
      allow 192.168.100
      allow 192.168.101
      allow 192.168.102
    '';
  };
}
