{
  programs.wezterm = {

    enable = true;
    extraConfig = ''
      local p = 11
      return {
      	enable_tab_bar = false,
      	enable_scroll_bar = false,
      	window_padding = {
      		left = p,
      		right = p,
      		top = p,
      		bottom = p,
      	},
        front_end = 'OpenGL',
        freetype_load_target = 'Light',
        freetype_render_target = 'HorizontalLcd',
        cell_width = 0.9,
        font = {
          size = 8,
          weight = "Bold"
        }
      }
    '';
  };
}
