{ config, pkgs, ... }:

{
  # Ollama AI service
  services.ollama = {
    enable = true;
    acceleration = "cuda";  # Use "rocm" for AMD, null for CPU
    loadModels = [ "llama3.2:3b" ];
  };

  # Enable nix-ld for VSCode Remote SSH and other dynamic binaries
  programs.nix-ld.enable = true;

  # Development packages
  environment.systemPackages = with pkgs; [
    # Go development
    go
    gopls
    go-tools
    
    # Python development
    python312Packages.virtualenv
    python312Packages.setuptools
    
    # Node.js ecosystem
    nodePackages.npm
    nodePackages.yarn
    nodePackages.pnpm
    nodePackages.typescript
    
    # Database tools
    postgresql
    redis
    
    # API testing
    postman
    httpie
  ];
}
