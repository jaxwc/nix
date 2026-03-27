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
      proc_gradient = true;
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
      save_config_on_exit = true;
    };

    themes.${theme.name} = ''
      theme[main_bg]="${c.bg}"
      theme[main_fg]="${c.fg}"
      theme[title]="${c.fg}"
      theme[hi_fg]="${c.orange}"
      theme[selected_bg]="${c.bg_highlight}"
      theme[selected_fg]="${c.cyan}"
      theme[inactive_fg]="${c.dark5}"
      theme[graph_text]="${c.fg}"
      theme[meter_bg]="${c.bg_dark}"
      theme[proc_misc]="${c.cyan}"
      theme[cpu_box]="${c.border_highlight}"
      theme[mem_box]="${c.border_highlight}"
      theme[net_box]="${c.border_highlight}"
      theme[proc_box]="${c.border_highlight}"
      theme[div_line]="${c.border_highlight}"
      theme[temp_start]="${c.green}"
      theme[temp_mid]="${c.yellow}"
      theme[temp_end]="${c.red}"
      theme[cpu_start]="${c.green}"
      theme[cpu_mid]="${c.yellow}"
      theme[cpu_end]="${c.red}"
      theme[free_start]="${c.green}"
      theme[free_mid]="${c.yellow}"
      theme[free_end]="${c.red}"
      theme[cached_start]="${c.green}"
      theme[cached_mid]="${c.yellow}"
      theme[cached_end]="${c.red}"
      theme[available_start]="${c.green}"
      theme[available_mid]="${c.yellow}"
      theme[available_end]="${c.red}"
      theme[used_start]="${c.green}"
      theme[used_mid]="${c.yellow}"
      theme[used_end]="${c.red}"
      theme[download_start]="${c.green}"
      theme[download_mid]="${c.yellow}"
      theme[download_end]="${c.red}"
      theme[upload_start]="${c.green}"
      theme[upload_mid]="${c.yellow}"
      theme[upload_end]="${c.red}"
      theme[process_start]="${c.green}"
      theme[process_mid]="${c.yellow}"
      theme[process_end]="${c.red}"
    '';
  };
}
