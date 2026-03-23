{
  pkgs,
  theme,
  ...
}: let
  c = theme.colors;
in {
  programs.tmux = {
    enable = true;

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      {
        plugin = tmux-sessionx;
        extraConfig = ''
          set -g @sessionx-bind 'o'
          set -g @sessionx-window-mode 'on'
          set -g @sessionx-tree-mode 'on'
          set -g @sessionx-preview-enabled 'true'
          set -g @sessionx-window-height '80%'
          set -g @sessionx-window-width '80%'
        '';
      }
    ];

    extraConfig = ''
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf
      set -g prefix C-M-S-C-s

      set -g mouse on
      set -g base-index 1
      set -g pane-base-index 1
      set -g renumber-windows on
      set -g escape-time 0
      set -g repeat-time 1000
      set -g history-limit 10000

      unbind %
      bind | split-window -h -c "#{pane_current_path}"

      unbind '"'
      bind - split-window -v -c "#{pane_current_path}"
      bind -r m resize-pane -Z

      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"

      set-window-option -g mode-keys vi
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      set -g @bg "${c.black}"
      set -g @fg "${c.text}"
      set -g @bg_subtle "${c.bg1}"
      set -g @ui_muted "${c.uiMuted}"
      set -g @red "${c.red}"
      set -g @orange "${c.orange}"
      set -g @yellow "${c.yellow}"
      set -g @green "${c.green}"
      set -g @cyan "${c.cyan}"
      set -g @blue "${c.blue}"
      set -g @purple "${c.purple}"
      set -g @magenta "${c.magenta}"
      set -g @transparent "${c.transparent}"

      set -g status-left-length 100
      set -g status-left ""
      set -ga status-left "#{?client_prefix,#{#[bg=#{@red},fg=#{@bg},bold]  #S },#{#[bg=#{@bg},fg=#{@green}]  #S }}"
      set -ga status-left "#[bg=#{@bg}]#[fg=#{@ui_muted}]#[none]│"
      set -ga status-left "#[bg=#{@bg}]#[fg=#{@blue}]  #{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}} "
      set -ga status-left "#[bg=#{@bg}]#[fg=#{@ui_muted}]#[none]#{?window_zoomed_flag,│,}"
      set -ga status-left "#[bg=#{@bg},fg=#{@yellow}]#{?window_zoomed_flag,  zoom ,}"
      set -g status-right ""

      set -g status-position bottom
      set -g status-style "bg=#{@transparent}"
      set -g status-justify "absolute-centre"

      set -wg automatic-rename on
      set -g automatic-rename-format "#{pane_current_command}"

      set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-style "bg=#{@bg},fg=#{@fg}"
      set -g window-status-last-style "bg=#{@bg},fg=#{@fg}"
      set -g window-status-activity-style "bg=#{@red},fg=#{@bg}"
      set -g window-status-bell-style "bg=#{@red},fg=#{@bg},bold"
      set -gF window-status-separator "#[bg=#{@bg},fg=#{@ui_muted}]│"

      set -g window-status-current-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-current-style "bg=#{@blue},fg=#{@bg},bold"

      set -g pane-border-lines simple
      set -g pane-border-style "fg=#{@ui_muted}"
      set -g pane-active-border-style "fg=#{@cyan}"
    '';
  };
}
