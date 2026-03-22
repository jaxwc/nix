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
      theme[main_bg]="${c.black}"
      theme[main_fg]="${c.text}"
      theme[title]="${c.text}"
      theme[hi_fg]="${c.blue}"
      theme[selected_bg]="${c.bg2}"
      theme[selected_fg]="${c.text}"
      theme[inactive_fg]="${c.muted}"
      theme[graph_text]="${c.text}"
      theme[meter_bg]="${c.bg1}"
      theme[proc_misc]="${c.purple}"
      theme[cpu_box]="${c.blue}"
      theme[mem_box]="${c.green}"
      theme[net_box]="${c.cyan}"
      theme[proc_box]="${c.orange}"
      theme[div_line]="${c.uiMuted}"
      theme[temp_start]="${c.green}"
      theme[temp_mid]="${c.yellow}"
      theme[temp_end]="${c.red}"
      theme[cpu_start]="${c.cyan}"
      theme[cpu_mid]="${c.blue}"
      theme[cpu_end]="${c.purple}"
      theme[free_start]="${c.green}"
      theme[free_mid]="${c.cyan}"
      theme[free_end]="${c.blue}"
      theme[cached_start]="${c.cyan}"
      theme[cached_mid]="${c.blue}"
      theme[cached_end]="${c.purple}"
      theme[available_start]="${c.yellow}"
      theme[available_mid]="${c.orange}"
      theme[available_end]="${c.red}"
      theme[used_start]="${c.green}"
      theme[used_mid]="${c.yellow}"
      theme[used_end]="${c.orange}"
      theme[download_start]="${c.cyan}"
      theme[download_mid]="${c.blue}"
      theme[download_end]="${c.purple}"
      theme[upload_start]="${c.orange}"
      theme[upload_mid]="${c.red}"
      theme[upload_end]="${c.magenta}"
      theme[process_start]="${c.green}"
      theme[process_mid]="${c.cyan}"
      theme[process_end]="${c.blue}"
    '';
  };
}
