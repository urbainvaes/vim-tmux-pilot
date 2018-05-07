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
Plug 'urbainvaes/vim-tmux-pilot'

" Uncomment to enable navigation of vim tabs
" let g:pilot_mode='wintab'

" Uncomment to enable creation of vim splits automatically
" let g:pilot_boundary='create'

" A useful mapping to use with this plugin
" nnoremap <nowait> <c-d> :q<cr>
```
In `~/.tmux.conf`, add:
```tmux
# Uncomment to enable navigation of tmux tabs
# PILOT_MODE=wintab

# Uncomment to enable creation of tmux splits automatically
# PILOT_BOUNDARY=create

PILOT_ROOT=$HOME/.vim/plugged/vim-tmux-pilot
source-file $PILOT_ROOT/pilot.tmux
```
Note that the `$PILOT_ROOT` environment variable needs to be defined for the plugin to work,
and that it is important to use `$HOME` instead of tilde (`~`),
because tilde expansion won't be performed on `PILOT_ROOT`.

# Usage

In the general case where `vim` is used inside a `tmux` session,
the order of precedence when `<ctrl-h>` or `<ctrl-l>` is issued from `vim` is as follows:

| Config               | `g:pilot_mode = 'winonly'` | `g:pilot_mode = 'wintab'`     |
| ------               | -------                    | -----------                   |
| `PILOT_MODE=winonly` | vsplit → tsplit            | vsplit → tsplit → vtab        |
| `PILOT_MODE=wintab`  | vsplit → tsplit → ttab     | vsplit → tsplit → vtab → ttab |

The variable `g:pilot_precedence` can be set to `'vtab'` to give `vim` tabs a precedence higher than that of `tmux` splits.
This ensures a s lightly more consistent behaviour,
in the sense that `<c-l><c-h>` will always bring us back to where we started from.

When trying to move across a bonudary of the navigation space,
i.e. when there isn't any container to move to in the specified direction,
the plugin will perform one of the following actions,
based on the configuration variables `g:pilot_boundary` and `PILOT_BOUNDARY`:

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
> # Set PILOT_BOUNDARY to 'create' for this session
> tmux setenv PILOT_BOUNDARY create
>
> # Set PILOT_BOUNDARY to 'reflect' for other sessions
> tmux setenv -g PILOT_BOUNDARY reflect
```

# Customization

In `vim`:

| Config               | Default (other values)               | Description                          |
| ------               | -------                              | -----------                          |
| `g:pilot_mode`       | `'winonly'` (`'wintab`')             | Mode of operation                    |
| `g:pilot_boundary`   | `'ignore'` (`'create'`, `'reflect'`) | Boundary condition                   |
| `g:pilot_precedence` | `'tsplit'` (`'vtab'`)                | Precedence between vtabs and tsplits |

In `tmux`:

| Config              | Default (other values)         | Description                           |
| ------              | -------                        | -----------                           |
| `PILOT_MODE`        | `winonly` (`wintab`)           | Mode of operation                     |
| `PILOT_BOUNDARY`    | `ignore` (`create`, `reflect`) | Boundary condition                    |
| `PILOT_ROOT`        | Empty (must be set)            | Root directory of `vim-tmux-pilot`    |
| `PILOT_EXCLUDE_ZSH` | Empty (`1`)                    | Disable insert mode keybinding in zsh |

# For zsh users

In `zsh`,
If you want the keybindings to be available only in normal mode,
add the following to your `~./zshrc`,
```zsh
if [ "$TMUX" != "" ]; then
    source $PILOT_ROOT/pilot.plugin.zsh
fi
```
and define `PILOT_EXCLUDE_ZSH=1` in your `~/.tmux.conf`:
```tmux
PILOT_EXCLUDE_ZSH=1
PILOT_ROOT=$HOME/.vim/plugged/vim-wintab
source-file $PILOT_ROOT/wintab.tmux.conf
```

# License

MIT
