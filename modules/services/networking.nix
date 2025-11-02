{ config, pkgs, ... }:

{
  # NetworkManager for WiFi/WLAN
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";  # Modern WiFi backend
  };

  # Bluetooth support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;  # Battery level indicator
      };
    };
  };

  # Bluetooth audio
  services.blueman.enable = true;

  # Firewall with nftables
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
    allowedUDPPorts = [ ];
  };
  
  networking.nftables.enable = true;

  # Alternative: UFW (uncomment if preferred over nftables)
  # programs.ufw = {
  #   enable = true;
  #   defaultIncomingPolicy = "deny";
  #   defaultOutgoingPolicy = "allow";
  #   allowedTCPPorts = [ 22 80 443 ];
  # };
}
