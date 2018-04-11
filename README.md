# Wintab

Inspired by [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator),
this plugin further extends the `<c-{h,l}>` mappings to switch between `vim` tabs or `tmux` windows when no `vim` split or `tmux` pane is available.

# Installation

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'urbainvaes/vim-wintab'
```

# Usage

Source the file `tmux/wintab.tmux.conf` from your `~/.tmux.conf`,
e.g. line

```tmux
source-file ~/.vim/plugged/vim-wintab/tmux/wintab.tmux.conf
```

# License

MIT
