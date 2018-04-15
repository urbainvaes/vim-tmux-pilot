# Wintab

Inspired by [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator),
this plugin further extends the `<c-{h,l}>` mappings to switch between `vim` tabs or `tmux` windows when no `vim` split or `tmux` pane is available,
similarly to what happens in the [i3](https://i3wm.org) window manager in a workspace with both tabs and windows.

# Installation

I suggest using [vim-plug](https://github.com/junegunn/vim-plug)
and sourcing the appropriate files from `~/.zshrc` and `~/.tmux.conf`.

In `~/.vimrc`, add:
```vim
Plug 'urbainvaes/vim-wintab'
```
In `~/.tmux.conf`, add:
```tmux
# Uncomment to disable navigation of tmux windows
# WINTAB_MODE=winonly
WINTAB_ROOT=$HOME/.vim/plugged/vim-wintab
source-file $WINTAB_ROOT/wintab.tmux.conf
```
Note that the `$WINTAB_ROOT` environment variable needs to be defined for the plugin to work,
and that it is important to use `$HOME` instead of tilde (`~`),
because tilde expansion won't be performed on `WINTAB_ROOT`.

# Usage

## In `vim` outside `tmux`
In this case,
all the plugin does is extend the `<ctrl-h>` and `<ctrl-l>` mappings
to navigate tabs if there is no window to switch to.
If there is no tab to navigate to, 
a new one will be created,
unless `g:wintab_enable_new_tab` is set to 0.

## In `vim` inside `tmux`
Set the environment variable `WINTAB_WINONLY` to `winonly` to disable tab navigation in `tmux`.

The order of precedence when `<ctrl-h>` or `<ctrl-l>` is issued from `vim` is as follows:
`vim` window → `viw` tab → `tmux` pane → `tmux` window.
The variable `g:wintab_order` can be used to customize this order;
one could for example set `g:wintab_order` to `['vwin', 'tpane', 'twin']`,
to give priority to `vim` windows (`'vwin'`), then `tmux` panes (`'tpane'`), then `tmux` windows (`'twin'`).

## For zsh users: issue navigation only in normal mode
In `zsh`,
If you want the keybindings to be available only in normal mode,
add the following to your `~./zshrc`,
```zsh
if [ "$TMUX" != "" ]; then
    source $WINTAB_ROOT/wintab.plugin.zsh
fi
```
and define `WINTAB_DISABLE_ZSH_INSERT=1` in your `~/.tmux.conf`:
```tmux
WINTAB_DISABLE_ZSH_INSERT=1
WINTAB_ROOT=$HOME/.vim/plugged/vim-wintab
source-file $WINTAB_ROOT/wintab.tmux.conf
```

# Customization

| Config                    | Default                             | Description                |
| ------                    | -------                             | -----------                |
| `g:wintab_order`          | `['vwin', 'tpane', 'vtab', 'twin']` | Custom order of precedence |
| `g:wintab_enable_new_tab` | `1` | Create new  |

# License

MIT
