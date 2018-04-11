# Wintab

Inspired by [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator),
this plugin further extends the `<c-{h,l}>` mappings to switch between `vim` tabs or `tmux` windows when no `vim` split or `tmux` pane is available.

# Installation

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'urbainvaes/vim-wintab'
```

# Usage

Add the following to your `~/.tmux.conf` (most of this code comes from [here](https://github.com/christoomey/vim-tmux-navigator)).

```tmux
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind -n C-h if-shell "$is_vim" "send-keys C-h" 'if-shell "[ #{pane_at_left} -eq 1 ]" "select-window -p" "select-pane -L"'
bind -n C-l if-shell "$is_vim" "send-keys C-l" 'if-shell "[ #{pane_at_right} -eq 1 ]" "select-window -n" "select-pane -R"'
bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
```

# License

MIT
