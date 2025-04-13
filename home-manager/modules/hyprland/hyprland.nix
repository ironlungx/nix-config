{pkgs, ...}: {
  home.packages = with pkgs; [
    jq
    libnotify
    hyprshot
    grim
    slurp
    playerctl
    cliphist
    wl-clipboard
    hyprpolkitagent
    swayosd
  ];

  wayland.windowManager.hyprland = {
    systemd.enable = false;
    enable = true;
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        "DVI-D-1, 1920x1200,0x00,1"
        "WAYLAND-1, disable"
      ];

      ###################
      ### MY PROGRAMS ###
      ###################

      # See https://wiki.hyprland.org/Configuring/Keywords/

      # Set programs that you use
      "$terminal" = "${pkgs.kitty}/bin/kitty";
      "$browser" = "${pkgs.firefox}/bin/firefox";
      "$fileManager" = "${pkgs.nautilus}/bin/nautilus";
      "$menu" = "rofi -show drun";
      "$screenshot" = "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";

      #################
      ### AUTOSTART ###
      #################

      exec-once = [
        "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY"
        "${pkgs.pyprland}/bin/pypr"
        "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store"
        "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store"
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "${pkgs.dunst}/bin/dunst"
        "${pkgs.waybar}/bin/waybar"
        "swayosd-server"
      ];

      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################

      # See https://wiki.hyprland.org/Configuring/Environment-variables/

      env = [
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,24"
        # "HYPRCURSOR_SIZE,24"

        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      #####################
      ### LOOK AND FEEL ###
      #####################

      # Refer to https://wiki.hyprland.org/Configuring/Variables/

      # https://wiki.hyprland.org/Configuring/Variables/#general
      general = {
        gaps_in = "5";
        gaps_out = "20";

        border_size = "2";

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = "false";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = "false";

        layout = "master";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 10;
        rounding_power = 2;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          # color = "rgba(1a1a1aee)";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations = {
        enabled = true;

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
      # "Smart gaps" / "No gaps when only"
      # uncomment all if you wish to use that.
      # workspace = w[tv1], gapsout:0, gapsin:0
      # workspace = f[1], gapsout:0, gapsin:0
      # windowrule = bordersize 0, floating:0, onworkspace:w[tv1]
      # windowrule = rounding 0, floating:0, onworkspace:w[tv1]
      # windowrule = bordersize 0, floating:0, onworkspace:f[1]
      # windowrule = rounding 0, floating:0, onworkspace:f[1]

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below;;
        preserve_split = true; # You probably want this
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
        new_status = "inherit";
        allow_small_split = true;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
      };

      #############
      ### INPUT ###
      #############

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = "us";

        follow_mouse = 1;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

        touchpad = {
          natural_scroll = false;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures = {
        workspace_swipe = false;
      };

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      ###################
      ### KEYBINDINGS ###
      ###################

      # See https://wiki.hyprland.org/Configuring/Keywords/
      "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier
      bind = [
        "$mainMod SHIFT, Return, exec, $terminal"
        "$mainMod CTRL, Return, exec, $browser"
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod CTRL, Escape, exit,"

        "$mainMod, E, exec, $fileManager"
        "$mainMod, P, exec, $menu"
        "$mainMod, U, fullscreen"

        "$mainMod, H, movefocus, l"
        "$mainMod, J, movefocus, d"
        "$mainMod, K, movefocus, u"
        "$mainMod, L, movefocus, r"

        "$mainMod CTRL, H, movewindow, l"
        "$mainMod CTRL, J, movewindow, d"
        "$mainMod CTRL, K, movewindow, u"
        "$mainMod CTRL, L, movewindow, r"

        "$mainMod, Return, layoutmsg, swapwithmaster master"

        "$mainMod, comma, layoutmsg, addmaster"
        "$mainMod, period, layoutmsg, removemaster"

        "$mainMod, t, togglefloating"

        "$mainMod, A, workspace, 1"
        "$mainMod, S, workspace, 2"
        "$mainMod, D, workspace, 3"
        "$mainMod, F, workspace, 4"
        "$mainMod, G, workspace, 5"
        "$mainMod, Z, workspace, 6"
        "$mainMod, X, workspace, 7"

        "$mainMod SHIFT, A, movetoworkspace, 1"
        "$mainMod SHIFT, S, movetoworkspace, 2"
        "$mainMod SHIFT, D, movetoworkspace, 3"
        "$mainMod SHIFT, F, movetoworkspace, 4"
        "$mainMod SHIFT, G, movetoworkspace, 5"
        "$mainMod SHIFT, Z, movetoworkspace, 6"
        "$mainMod SHIFT, X, movetoworkspace, 7"

        "$mainMod, V, exec, cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"

        "$mainMod, M, exec, $screenshot"
        "$mainMod, Escape, exec, hyprlock"
      ];

      binde = [
        "$mainMod SHIFT, H, resizeactive, -20 0"
        "$mainMod SHIFT, J, resizeactive, 0 20"
        "$mainMod SHIFT, K, resizeactive, 0 -20"
        "$mainMod SHIFT, L, resizeactive, 20 0"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume=+5"
        ",XF86AudioLowerVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume=-5"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

      # Example windowrule
      # windowrule = float,class:^(kitty)$,title:^(kitty)$

      # Ignore maximize requests from apps. You'll probably like this.
      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "float, title:Vesktop"
      ];
    };
    extraConfig = ''
      $reset = hyprctl dispatch submap reset &&
      bind = $mainMod, W, submap, scratchpads
      submap = scratchpads

      binde = , D, exec, $reset ${pkgs.pyprland}/bin/pypr toggle "vesktop"
      binde = , S, exec, $reset ${pkgs.pyprland}/bin/pypr toggle "spotify"
      binde = , Return, exec, $reset ${pkgs.pyprland}/bin/pypr toggle "term"

      submap = reset
    '';
  };
}
