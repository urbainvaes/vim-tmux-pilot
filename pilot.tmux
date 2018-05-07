# The MIT License (MIT)
#
# Copyright (c) 2018 Urbain Vaes
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

TMUX_WINTABCMD=$PILOT_ROOT/sh/tmux-wintabcmd

is_vim_or_fzf="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?(g?(view|n?vim?x?)(diff)?|fzf)$'"

is_shell="[ '$WINTAB_EXCLUDE_ZSH' == 1 ] \
          && ps -o tpgid= -o pid= -o comm= -t '#{pane_tty}' \
          | awk '$1 == $2 { print $3 }' | grep -ixq 'zsh'"

bind -n C-h if-shell "$is_shell || $is_vim_or_fzf" "send-keys C-h" \
         "run-shell 'sh $TMUX_WINTABCMD h'"
bind -n C-j if-shell "$is_shell || $is_vim_or_fzf" "send-keys C-j" \
         "run-shell 'sh $TMUX_WINTABCMD j'"
bind -n C-k if-shell "$is_shell || $is_vim_or_fzf" "send-keys C-k" \
         "run-shell 'sh $TMUX_WINTABCMD k'"
bind -n C-l if-shell "$is_shell || $is_vim_or_fzf" "send-keys C-l" \
         "run-shell 'sh $TMUX_WINTABCMD l'"

bind-key -T copy-mode-vi C-h run-shell 'sh $TMUX_WINTABCMD h'
bind-key -T copy-mode-vi C-j run-shell 'sh $TMUX_WINTABCMD j'
bind-key -T copy-mode-vi C-k run-shell 'sh $TMUX_WINTABCMD k'
bind-key -T copy-mode-vi C-l run-shell 'sh $TMUX_WINTABCMD l'

# vim: ft=tmux
