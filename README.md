# Vim-tmux-pilot (previously Vim-tmux-wintab)

Inspired by [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator),
this plugin further extends the `<c-{h,l}>` mappings to switch between `vim` or `tmux` tabs when no `vim` or `tmux` split is available,
similarly to what happens in the [i3](https://i3wm.org) window manager in a workspace with both tabs and splits.
It can additionally be configured to automatically create a container when reaching the boundary of the navigation space.

# Terminology

To avoid ambiguities,
we use the simplified terminology {`vim`,`tmux`}-{splits,tabs} and
the abbreviations {v,t}{splits,tabs}
to refer to {`vim`-{windows,tabs},`tmux`-{panes,windows}}, respectively.
The term "navigation space" is used to refer to the set of containers that can be accessed via the keys `c-{h,j,k,l}`.

# Installation

I recommend using [vim-plug](https://github.com/junegunn/vim-plug)
and sourcing the appropriate file from `~/.tmux.conf`.

In `~/.vimrc`, add:
```vim
Plug 'urbainvaes/vim-wintab'

" Uncomment to enable navigation of vim tabs
" let g:wintab_mode='wintab'

" Uncomment to enable creation of vim splits automatically
" let g:wintab_boundary='create'

" A useful mapping to use with this plugin
" nnoremap <nowait> <c-d> :q<cr>
```
In `~/.tmux.conf`, add:
```tmux
# Uncomment to enable navigation of tmux tabs
# WINTAB_MODE=wintab

# Uncomment to enable creation of tmux splits automatically
# WINTAB_BOUNDARY=create

WINTAB_ROOT=$HOME/.vim/plugged/vim-wintab
source-file $WINTAB_ROOT/wintab.tmux.conf
```
Note that the `$WINTAB_ROOT` environment variable needs to be defined for the plugin to work,
and that it is important to use `$HOME` instead of tilde (`~`),
because tilde expansion won't be performed on `WINTAB_ROOT`.

# Usage

In the general case where `vim` is used inside a `tmux` session,
the order of precedence when `<ctrl-h>` or `<ctrl-l>` is issued from `vim` is as follows:

| Config                | `g:wintab_mode = 'winonly'` | `g:wintab_mode = 'wintab'`    |
| ------                | -------                     | -----------                   |
| `WINTAB_MODE=winonly` | vsplit → tsplit             | vsplit → tsplit → vtab        |
| `WINTAB_MODE=wintab`  | vsplit → tsplit → ttab      | vsplit → tsplit → vtab → ttab |

The variable `g:wintab_precedence` can be set to `'vtab'` to give `vim` tabs a precedence higher than that of `tmux` splits.
This ensures a slightly more consistent behaviour,
in the sense that `<c-l><c-h>` will always bring us back to where we started from.

When trying to move across a bonudary of the navigation space,
i.e. when there isn't any container to move to in the specified direction,
the plugin will perform one of the following actions,
based on the configuration variables `g:wintab_boundary` and `WINTAB_BOUNDARY`:

- If the behaviour at the boundary is set to **create**,
  a container corresponding to the type of lowest precedence will be created.
  That way, the behaviour is consistent between containers.

- If the behaviour at the boundary is set to **reflect**,
  the focus will move to the opposite container of lowest precedence.
  In case there isn't one,
  containers of lower precedence will be used,
  or the key will be sent to the program is none is available.

- If the behaviour at the boundary is set to **ignore**,
  the key is simply ignored (in `vim`)
  or fed to the program running in the container (in `tmux`).

Internally, the `tmux` command `showenv [-g]` is used to read configuration variables in `tmux`.
This means that these variables can be changed on the fly from within `tmux`
using the `tmux` command `setenv [-g]`.
Variables in the local environment (declared without the `-g` flag)
take precedence over variables in the global environement.
For example, in a shell:
```bash
> # Set WINTAB_BOUNDARY to 'create' for this session
> tmux setenv WINTAB_BOUNDARY create
>
> # Set WINTAB_BOUNDARY to 'reflect' for other sessions
> tmux setenv -g WINTAB_BOUNDARY reflect
```

# Customization

In `vim`:

| Config                | Default (other values)               | Description                          |
| ------                | -------                              | -----------                          |
| `g:wintab_mode`       | `'wintab'` (`'winonly`')             | Mode of operation                    |
| `g:wintab_boundary`   | `'reflect'` (`'create'`, `'ignore'`) | Boundary condition                   |
| `g:wintab_precedence` | `'tsplit'` (`'vtab'`)                | Precedence between vtabs and tsplits |

In `tmux`:

| Config               | Default (other values)         | Description                           |
| ------               | -------                        | -----------                           |
| `WINTAB_MODE`        | `wintab` (`winonly`)           | Mode of operation                     |
| `WINTAB_BOUNDARY`    | `reflect` (`create`, `ignore`) | Boundary condition                    |
| `WINTAB_ROOT`        | Empty (must be set)            | Root directory of `vim-wintab`        |
| `WINTAB_EXCLUDE_ZSH` | Empty (`1`)                    | Disable insert mode keybinding in zsh |

# For zsh users

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

# License

MIT
