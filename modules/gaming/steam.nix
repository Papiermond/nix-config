{ config, pkgs, ... }:

{
  # Enable graphics acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Essential for Steam
  };

  # GPU drivers (choose based on your hardware)
  services.xserver.videoDrivers = [ "amdgpu" ];  # or "nvidia" or "intel"
  
  # NVIDIA-specific configuration (uncomment if using NVIDIA)
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   open = true;  # For RTX 20 series and newer
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  # Steam with all features
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    
    # Declarative Proton GE
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # Gamemode for performance optimization
  programs.gamemode.enable = true;

  # Gaming utilities
  environment.systemPackages = with pkgs; [
    # Performance monitoring
    mangohud
    gamescope
    
    # Proton management
    protonup-qt
    
    # Alternative launchers
    lutris
    heroic
    
    # Vulkan tools
    vulkan-tools
    
    # SDL libraries
    SDL2
    SDL2_ttf
    SDL2_image
    SDL2_mixer
    
    # Wine for non-Steam games
    wine
    winetricks
  ];

  # Kernel parameters for gaming
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };
}
