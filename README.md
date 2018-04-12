# Wintab

Inspired by [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator),
this plugin further extends the `<c-{h,l}>` mappings to switch between `vim` tabs or `tmux` windows when no `vim` split or `tmux` pane is available.

# Installation

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'urbainvaes/vim-wintab'
```
# Usage

The plugin has two modes:

- *win* mode, to seamlessly navigate `vim` windows and `tmux` panes with `<ctrl-{h,j,k,l}>`, à la [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator).
A difference with that plugin is that [vim-wintab](https://github.com/urbainvaes/vim-wintab) will not bind keys when it is not needed
(for example, the `<c-h>` and `<c-l>` readline keybindings will be available in the leftmost and rightmost `tmux` pane, respectively).

- *wintab* mode, to additionally navigate `vim` tabs and `tmux` windows.

Use `WintabToggleMode` to change between them.
In *wintab* mode,
the order of precedence when `<ctrl-h>` or `<ctrl-l>` is pressed from `vim` is as follows: `vim` window → `viw` tab → `tmux` pane → `tmux` window.
For more advanced customization,
the variable `g:wintab_order` can be set to define the order of precedence desired,
and the value of `g:wintab_mode` will then be ignored.
One could for example set `g:wintab_order` to `['vwin', 'tpane', 'twin']`,
to give priority to `vim` windows (`'vwin'`), then `tmux` panes (`'tpane'`), then `tmux` windows (`'twin'`).

`tmux` keybindings are defined automatically by the plugin, 
but to make them persistent and available in all sessions,
source one of the files `tmux/{win,wintab}.conf` from your `~/.tmux.conf`,
e.g. if you installed with [vim-plug](https://github.com/junegunn/vim-plug):

```tmux
source-file ~/.vim/plugged/vim-wintab/tmux/wintab.tmux.conf
```

# Customization

| Config           | Default    | Description                              |
| ------           | -------    | -----------                              |
| `g:wintab_mode`  | `"wintab"` | Set to `"win"` to disable tab navigation |
| `g:wintab_order` | None       | Custom order of priority                 |
| `g:wintab_maps`  | `"1"`      | Use default mappings, `<ctrl-{h,j,k,l}>` |

If you do not wish to use the default mappings,
`<Plug>` mappings are available; see source code.

# License

MIT
