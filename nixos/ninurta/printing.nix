{ pkgs, ... }:
{
  hardware = {
    printers = {
      ensurePrinters = [
        {
          name = "Brother_HL-L2300D";
          model = "drv:///brlaser.drv/brl2300d.ppd";
          location = "BS";
          deviceUri = "usb://Brother/HL-L2310D%20series?serial=E78096H3N771439";
          ppdOptions = {
            PageSize = "A4";
            Duplex = "DuplexNoTumble";
          };
        }
      ];
    };
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
    # Remove all state at the start of the service
    stateless = true;
    listenAddresses = [ "192.168.101.184:631" "fd42:9c3b:f96d:101:4a21:bff:fe3e:9cfe:631" ];
    allowFrom = [ "from 192.168.101.0/24" ];
    browsing = true;
    defaultShared = true;
  };
}
