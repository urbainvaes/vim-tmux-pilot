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

In `vim`,
this plugin extends the `<ctrl-h>` and `<ctrl-l>` mappings
to enable navigation of tabs when there is no window to switch to.
If there is no tab to switch to either,
a new tab will be created or the focus will move to the opposite tab,
depending on the value of `g:wintab_tabs_boundary`.

When using `vim` inside a `tmux` session,
the order of precedence when `<ctrl-h>` or `<ctrl-l>` is issued from `vim` is as follows:
`vim` window → `viw` tab → `tmux` pane → `tmux` window.
The variable `g:wintab_precedence` can be set to `'vtab'` to swap the positions of `vim` tabs  and `tmux` panes in the order of precedence.

## For zsh users
In `zsh`,
If you want the keybindings to be available only in normal mode,
add the following to your `~./zshrc`,
```zsh
if [ "$TMUX" != "" ]; then
    source $WINTAB_ROOT/wintab.plugin.zsh
fi
```
and define `WINTAB_EXCLUDE_ZSH=1` in your `~/.tmux.conf`:
```tmux
WINTAB_EXCLUDE_ZSH=1
WINTAB_ROOT=$HOME/.vim/plugged/vim-wintab
source-file $WINTAB_ROOT/wintab.tmux.conf
```

# Customization

In `vim`:

| Config                | Default (other values)   | Description                                |
| ------                | -------                  | -----------                                |
| `g:wintab_mode`       | `'wintab'` (`'winonly`') | Mode of operation                          |
| `g:wintab_boundary`   | `'reflect'` (`'create'`) | Behaviour when no tab is available         |
| `g:wintab_precedence` | `'tpane'` (`'vtab'`)     | Precedence between vim tabs and tmux panes |

In `tmux`:

| Config               | Default (other possible values) | Description                           |
| ------               | -------                         | -----------                           |
| `WINTAB_MODE`        | `wintab` (`winonly`)            | Mode of operation                     |
| `WINTAB_BOUNDARY`    | `reflect` (`create`, `ignore`)  | Behaviour when no tab is available    |
| `WINTAB_ROOT`        | None (must be set)              | Root directory of `vim-wintab`        |
| `WINTAB_EXCLUDE_ZSH` | empty (`1`)                     | Disable insert mode keybinding in zsh |

# License

MIT
