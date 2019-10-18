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

%if #{==:#{PILOT_KEY_H},}
KEY_H=C-h
%else
KEY_H=$PILOT_KEY_H
%endif

%if #{==:#{PILOT_KEY_J},}
KEY_J=C-j
%else
KEY_J=$PILOT_KEY_J
%endif

%if #{==:#{PILOT_KEY_K},}
KEY_K=C-k
%else
KEY_K=$PILOT_KEY_K
%endif

%if #{==:#{PILOT_KEY_L},}
KEY_L=C-l
%else
KEY_L=$PILOT_KEY_L
%endif

# Fix for "grep: empty (sub)expression". See issue 10.
%if #{==:#{PILOT_IGNORE},}
PILOT_IGNORE=WILL_NEVER_MATCH
%endif

TMUX_WINTABCMD=$PILOT_ROOT/sh/tmux-wintabcmd
IS_VIM_OR_FZF="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?(g?(view|n?vim?x?)(diff)?|fzf|$PILOT_IGNORE)$'"

bind -n $KEY_H if-shell "$IS_VIM_OR_FZF" "send-keys $KEY_H" \
         "run-shell 'sh $TMUX_WINTABCMD h'"
bind -n $KEY_J if-shell "$IS_VIM_OR_FZF" "send-keys $KEY_J" \
         "run-shell 'sh $TMUX_WINTABCMD j'"
bind -n $KEY_K if-shell "$IS_VIM_OR_FZF" "send-keys $KEY_K" \
         "run-shell 'sh $TMUX_WINTABCMD k'"
bind -n $KEY_L if-shell "$IS_VIM_OR_FZF" "send-keys $KEY_L" \
         "run-shell 'sh $TMUX_WINTABCMD l'"

bind-key -T copy-mode-vi $KEY_H run-shell 'sh $TMUX_WINTABCMD h'
bind-key -T copy-mode-vi $KEY_J run-shell 'sh $TMUX_WINTABCMD j'
bind-key -T copy-mode-vi $KEY_K run-shell 'sh $TMUX_WINTABCMD k'
bind-key -T copy-mode-vi $KEY_L run-shell 'sh $TMUX_WINTABCMD l'

# Pause the plugin
bind-key F11 run-shell 'sh $TMUX_WINTABCMD toggle-pause'

# Re-add default functionality
# bind $KEY_H send-keys C-h
# bind $KEY_J send-keys C-j
# bind $KEY_K send-keys C-k
# bind $KEY_L send-keys C-l

# vim: ft=tmux
