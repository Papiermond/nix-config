{ config, pkgs, inputs, ... }:

{
  home.username = "yourusername";
  home.homeDirectory = "/home/yourusername";
  home.stateVersion = "24.05";

  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "thunar";
      "$menu" = "wofi --show drun";
      
      # Monitor configuration
      monitor = ",preferred,auto,1";
      
      # Autostart programs
      exec-once = [
        "waybar &"
        "hyprpaper &"
        "dunst &"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "nm-applet --indicator &"
        "blueman-applet &"
      ];
      
      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];
      
      # Visual settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };
      
      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.95;
        
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
        
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };
      
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0;
      };
      
      # Keybindings
      bind = [
        # Program launching
        "$mod, RETURN, exec, $terminal"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating"
        "$mod, D, exec, $menu"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, B, exec, brave"
        "$mod, C, exec, code"
        
        # Focus movement
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        
        # Workspace switching
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move windows to workspaces
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
        # Scratchpad
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        
        # Screenshots
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SHIFT, Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"
        
        # Clipboard history
        "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
      ];
      
      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      
      # Media keys
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
      
      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];
    };
  };

  # Alacritty terminal
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        padding = {
          x = 10;
          y = 10;
        };
        decorations = "full";
      };
      
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = 12.0;
      };
      
      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
        normal = {
          black = "#45475a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#bac2de";
        };
      };
    };
  };

  # Waybar status bar
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["tray" "pulseaudio" "network" "cpu" "memory" "battery"];
        
        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };
        
        "hyprland/window" = {
          format = "{}";
          max-length = 50;
        };
        
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };
        
        cpu = {
          format = " {usage}%";
          tooltip = false;
        };
        
        memory = {
          format = " {}%";
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = ["" "" "" "" ""];
        };
        
        network = {
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ifname}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
        };
        
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
        
        tray = {
          spacing = 10;
        };
      };
    };
    
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }
      
      window#waybar {
        background: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
      }
      
      #workspaces button {
        padding: 0 5px;
        color: #cdd6f4;
        background: transparent;
      }
      
      #workspaces button.active {
        background: #89b4fa;
        color: #1e1e2e;
        border-radius: 5px;
      }
      
      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #window {
        padding: 0 10px;
        margin: 0 2px;
      }
      
      #battery.charging {
        color: #a6e3a1;
      }
      
      #battery.warning:not(.charging) {
        color: #f9e2af;
      }
      
      #battery.critical:not(.charging) {
        color: #f38ba8;
      }
    '';
  };

  # Wofi application launcher
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      allow_images = true;
      image_size = 40;
      insensitive = true;
    };
    
    style = ''
      window {
        margin: 0px;
        border: 2px solid #89b4fa;
        background-color: #1e1e2e;
        border-radius: 10px;
      }
      
      #input {
        margin: 5px;
        border: none;
        color: #cdd6f4;
        background-color: #313244;
        border-radius: 5px;
      }
      
      #entry:selected {
        background-color: #89b4fa;
        color: #1e1e2e;
        border-radius: 5px;
      }
      
      #text {
        color: #cdd6f4;
      }
    '';
  };

  # Hyprpaper wallpaper daemon
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      
      preload = [
        "~/Pictures/wallpapers/wallpaper.png"
      ];
      
      wallpaper = [
        ",~/Pictures/wallpapers/wallpaper.png"
      ];
    };
  };

  # Dunst notification daemon
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#89b4fa";
        font = "JetBrainsMono Nerd Font 10";
      };
      
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };
      
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };
      
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#f38ba8";
        frame_color = "#f38ba8";
        timeout = 0;
      };
    };
  };

  # btop system monitor
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "Default";
      theme_background = false;
      vim_keys = true;
      update_ms = 1000;
      proc_sorting = "cpu lazy";
      proc_tree = true;
    };
  };

  # VSCode configuration
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      jnoortheen.nix-ide
      ms-python.python
      golang.go
      ms-azuretools.vscode-docker
      vscodevim.vim
    ];
    
    userSettings = {
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
      "editor.fontLigatures" = true;
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "workbench.colorTheme" = "Default Dark+";
      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
      "files.autoSave" = "afterDelay";
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # Shell configuration (zsh)
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "eza -la";
      update = "sudo nixos-rebuild switch --flake /etc/nixos#myhostname";
      upgrade = "sudo nixos-rebuild switch --upgrade --flake /etc/nixos#myhostname";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#myhostname";
      gs = "git status";
      gp = "git pull";
      gc = "git commit";
    };
    
    initExtra = ''
      # Starship prompt
      eval "$(starship init zsh)"
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch = {
        symbol = " ";
      };
      nix_shell = {
        symbol = " ";
      };
    };
  };

  # Additional user packages
  home.packages = with pkgs; [
    # CLI utilities
    ripgrep
    fd
    fzf
    eza
    bat
    htop
    neofetch
    
    # Clipboard management
    cliphist
    
    # Fonts
    jetbrains-mono
    nerdfonts
    
    # Development
    go
    
    # Screenshot tools
    grim
    slurp
    swappy
    
    # Brightness control
    brightnessctl
  ];

  # Enable Home Manager
  programs.home-manager.enable = true;
}
