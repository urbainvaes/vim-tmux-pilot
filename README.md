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

In `vim` outside of `tmux`,
this plugin extends the `<ctrl-h>` and `<ctrl-l>` mappings
to enable navigation of tabs when there is no window to switch to.
If there is no tab to switch to either,
a new window or tab will be created,
depending on the value of `g:wintab_enable_new_tab`.

Inside a `tmux` session,
the `vim` plugin additionally allows switching to `tmux` panes and windows.
The order of precedence when `<ctrl-h>` or `<ctrl-l>` is issued from `vim` is as follows:
`vim` window → `viw` tab → `tmux` pane → `tmux` window.
The variable `g:wintab_order` can be used to customize this order;
one could for example set `g:wintab_order` to `['vwin', 'tpane', 'twin']`,
to give priority to `vim` windows (`'vwin'`), then `tmux` panes (`'tpane'`), then `tmux` windows (`'twin'`).

In `tmux`,
set the environment variable `WINTAB_MODE` to `winonly` to disable tab navigation in `tmux`.

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

In `vim`:

| Config                | Default (other possible values)     | Description                                  |
| ------                | -------                             | -----------                                  |
| `g:wintab_order`      | `['vwin', 'tpane', 'vtab', 'twin']` | Order of precedence                          |
| `g:wintab_enable_new` | `"tab"` (`"win"`, `"no"`)           | Enable creation of new `vim` windows or tabs |

In `tmux`:

| Config                      | Default (other possible values) | Description                                    |
| ------                      | -------                         | -----------                                    |
| `WINTAB_ROOT`               | None (must be set)              | Root directory of `vim-wintab`                 |
| `WINTAB_NEW`                | `win` (`pane`, `no`)            | Enable creation of new `tmux` panes or windows |
| `WINTAB_MODE`               | `wintab` (`winonly`)            | Set to `winonly` to disable tab navigation     |
| `WINTAB_DISABLE_ZSH_INSERT` | `"tab"` (`"win"`, `"no"`)       | Disable insert mode keybinding in zsh          |

# License

MIT
