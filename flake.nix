{
  description = "Complete NixOS Configuration with Hyprland";

  inputs = {
    # Main package repository - use unstable for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home Manager for user-level configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # Use same nixpkgs version
    };
    
    # Hyprland compositor
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs: {
    nixosConfigurations = {
      # Replace "myhostname" with your actual hostname
      nixos_btw = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };  # Pass inputs to modules
        modules = [
          # Hardware and system configuration
          ./hosts/nixos_btw/hardware-configuration.nix
          ./hosts/nixos_btw/configuration.nix
          
          # Hyprland module
          hyprland.nixosModules.default
          
          # Home Manager as NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yourusername = import ./home/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
