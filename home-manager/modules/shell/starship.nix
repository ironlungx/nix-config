{
  programs.starship = {
    enable = true;
    settings = {
      scan_timeout = 10;
      add_newline = false;
      format = "$directory $nix_shell $character";
      right_format = "$git_branch$cmd_duration";
      character = {
        success_symbol = "[ ](bold green)";
        error_symbol = "[ ](bold red)";
        vicmd_symbol = "[ ](bold yellow)";
        vimcmd_replace_symbol = "[ ](bold red)";
        vimcmd_replace_one_symbol = "[ ](bold red)";
      };
      username = {
        show_always = true;
        style_user = "bold bg:none fg:blue";
        format = "[$user]($style)";
      };
      hostname = {
        disabled = true;
        ssh_only = false;
        style = "bold bg:none fg:text";
        format = "@[$hostname]($style) ";
      };
      directory = {
        read_only = " ";
        truncation_length = 3;
        truncation_symbol = "./";
        style = "bold bright-purple";
      };
      git_branch = {
        format = "[$symbol $branch(:$remote_branch)]($style) ";
        symbol = "";
        style = "bold purple";
      };
      cmd_duration = {
        min_time = 2000;
        show_milliseconds = false;
        format = "took [$duration]($style)";
        style = "bold yellow";
        disabled = false;
      };
      line_break = {
        disabled = false;
      };
      nix_shell = {
        format = "[$symbol$name]($style) ";
        symbol = " ";
        style = "bold cyan";
        impure_msg = "impure";
        pure_msg = "pure";
        unknown_msg = "unknown";
        disabled = false;
      };
    };
  };
}
