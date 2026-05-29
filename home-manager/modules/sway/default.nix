{ home, pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = "Mod4";
      terminal = "ghostty";
      bars = [ ];

      # Gaps (inner + outer)
      gaps.inner = 8;
      gaps.outer = 4;

      # Optional: smart gaps/borders
      gaps.smartGaps = true;
      gaps.smartBorders = "on";

      # Border width (set to 0 for no border)
      window.border = 2;

      startup = [
        { command = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store"; }
        { command = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store"; }
        { command = "${pkgs.hyprpaper}/bin/hyprpaper"; }
        { command = "${pkgs.dunst}/bin/dunst"; }
        { command = "swayosd-server"; }
        { command = "blueman-applet"; }
        { command = "${pkgs.wayscriber}/bin/wayscriber --daemon"; }
        { command = "waybar"; }
      ];
    };

    extraConfig = ''
      set $menu "rofi -show drun"
      set $browser "zen-beta"
      set $screenshot "fish -c 'grim -g (slurp) - | wl-copy'"
      set $wayscriber "pkill -SIGUSR1 wayscriber"

      bindsym Mod4+p exec $menu
      bindsym Mod4+Shift+m exec $screenshot
      bindsym Mod4+Control+Return exec $browser

      bindsym XF86AudioRaiseVolume exec "${pkgs.swayosd}/bin/swayosd-client --output-volume=+5"
      bindsym XF86AudioLowerVolume exec "${pkgs.swayosd}/bin/swayosd-client --output-volume=-5"
      bindsym XF86AudioMute exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      bindsym XF86AudioNext exec "playerctl next"
      bindsym XF86AudioPrev exec "playerctl previous"         
      bindsym XF86AudioPause exec "playerctl play-pause"
      bindsym XF86AudioPlay exec "playerctl play-pause"

      bindsym Mod4+Shift+s exec $wayscriber
      bindsym Mod4+m exec "${pkgs.wl-kbptr}/bin/wl-kbptr"

      input type:keyboard {

        repeat_delay 200
        repeat_rate 30
      }
    '';
  };
}
