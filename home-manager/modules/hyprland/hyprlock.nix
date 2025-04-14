{config, ...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        no_fade_in = true;
        no_fade_out = true;
        hide_cursor = false;
        grace = 0;
        disable_loading_bar = true;
      };

      input-field = {
        monitor = "";
        "size " = " 250, 60";
        "outline_thickness " = 2;
        "dots_size " = " 0.2";
        "dots_spacing " = " 0.35";
        "dots_center " = true;
        "outer_color " = " rgba(0, 0, 0, 0)";
        "inner_color " = " rgba(0, 0, 0, 0.2)";
        "fade_on_empty " = false;
        "rounding " = " -1";
        "check_color " = " rgb(204, 136, 34)";
        "placeholder_text " = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
        "hide_input " = false;
        "position " = " 0, -200";
        "halign " = " center";
        "valign " = " center";
      };

      background = {
        monitor = "";
        blur_passes = 2;
        contrast = 1;
        brightness = 0.5;
        vibrancy = 0.2;
        vibrancy_darkness = 0.2;
      };

      label = [
        # TIME
        {
          "monitor" = "";
          "text" = "cmd[update:1000] date +\"%-I:%M\"";
          "font_size" = "95";
          "font_family" = "JetBrains Mono Extrabold";
          "position" = "0, 200";
          "halign" = "center";
          "valign" = "center";
        }
        {
          "monitor " = "";
          "text " = "cmd[update:1000] date +\"%A, %B %d\"";
          "font_size " = "22";
          "font_family " = "JetBrains Mono";
          "position " = "0, 300";
          "halign " = "center";
          "valign " = "center";
        }
        {
          "monitor " = "";
          "text " = ''cmd[update:1000] echo "  $(playerctl metadata --format '{{ artist }} - {{ title }}')"'';
          "font_size " = " 18";
          "font_family " = "JetBrains Mono Nerd Font";
          "position " = " 0, 50";
          "halign " = " center";
          "valign " = " bottom";
        }
      ];

      image = [
        {
          monitor = "";
          size = 100;
          position = "0, 75";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
