{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/services/docker.nix
    ../../modules/services/networking.nix
    ../../modules/gaming/steam.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Gaming-optimized kernel
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # Hostname
  networking.hostName = "nixos_btw";

  # Enable flakes and new Nix commands
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Timezone and locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  # Hyprland with proper integration
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  # XDG portal configuration for screensharing
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # PipeWire audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Essential tools
    git
    vim
    wget
    curl
    
    # Development tools
    vscode
    jetbrains.goland
    nodejs_22
    python312
    python312Packages.pip
    
    # Desktop applications
    brave
    xfce.thunar
    btop
    kitty  # Required for Hyprland default config
    
    # Wayland utilities
    grim          # Screenshots
    slurp         # Screen area selection
    wl-clipboard  # Clipboard management
    dunst         # Notifications
    pavucontrol   # Audio control
    networkmanagerapplet
  ];

  # Thunar with plugins
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
    ];
  };
  services.tumbler.enable = true;  # Thumbnail support

  # User account
  users.users.fabi = {
    isNormalUser = true;
    description = "fabi";
    extraGroups = [ 
      "wheel"           # sudo access
      "networkmanager"  # network control
      "docker"          # docker access
      "video"           # brightness control
      "audio"           # audio devices
    ];
  };

  # Allow unfree packages (required for Steam, VSCode, etc.)
  nixpkgs.config.allowUnfree = true;

  # Electron apps use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # System version (do not change after initial install)
  system.stateVersion = "24.05";
}
