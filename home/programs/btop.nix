{theme, ...}: let
  c = theme.colors;
in {
  programs.btop = {
    enable = true;

    settings = {
      color_theme = theme.name;
      theme_background = false;
      truecolor = true;
      vim_keys = true;
      rounded_corners = true;
      graph_symbol = "braille";
      update_ms = 2000;
      proc_sorting = "cpu lazy";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      proc_gradient = false;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      cpu_invert_lower = true;
      show_uptime = true;
      check_temp = true;
      temp_scale = "celsius";
      show_cpu_freq = true;
      clock_format = "%X";
      mem_graphs = true;
      show_swap = true;
      show_disks = true;
      net_auto = true;
      net_sync = true;
      show_battery = true;
      log_level = "WARNING";
      save_config_on_exit = false;
    };

    themes.${theme.name} = ''
      theme[main_bg]="${c.bg}"
      theme[main_fg]="${c.fg}"
      theme[title]="${c.fg}"
      theme[hi_fg]="${c.orange}"
      theme[selected_bg]="${c.bg_highlight}"
      theme[selected_fg]="${c.cyan}"
      theme[inactive_fg]="${c.comment}"
      theme[graph_text]="${c.fg_dark}"
      theme[meter_bg]="${c.bg_float}"
      theme[proc_misc]="${c.cyan}"
      theme[cpu_box]="${c.purple}"
      theme[mem_box]="${c.purple}"
      theme[net_box]="${c.purple}"
      theme[proc_box]="${c.purple}"
      theme[div_line]="${c.border_highlight}"
      theme[temp_start]="${c.green}"
      theme[temp_mid]="${c.yellow}"
      theme[temp_end]="${c.red}"
      theme[cpu_start]="${c.cyan}"
      theme[cpu_mid]="${c.purple}"
      theme[cpu_end]="${c.magenta}"
      theme[free_start]="${c.cyan}"
      theme[free_mid]="${c.blue}"
      theme[free_end]="${c.purple}"
      theme[cached_start]="${c.purple}"
      theme[cached_mid]="${c.magenta}"
      theme[cached_end]="${c.red}"
      theme[available_start]="${c.green}"
      theme[available_mid]="${c.cyan}"
      theme[available_end]="${c.blue}"
      theme[used_start]="${c.blue}"
      theme[used_mid]="${c.purple}"
      theme[used_end]="${c.magenta}"
      theme[download_start]="${c.cyan}"
      theme[download_mid]="${c.blue}"
      theme[download_end]="${c.purple}"
      theme[upload_start]="${c.magenta}"
      theme[upload_mid]="${c.red}"
      theme[upload_end]="${c.orange}"
      theme[process_start]="${c.cyan}"
      theme[process_mid]="${c.purple}"
      theme[process_end]="${c.magenta}"
    '';
  };
}
