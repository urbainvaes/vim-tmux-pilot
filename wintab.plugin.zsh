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

function wintabcmd {
    sh $WINTAB_ROOT/sh/tmux-wintabcmd $1
}

function wintabcmd_h { wintabcmd h }
function wintabcmd_j { wintabcmd j }
function wintabcmd_k { wintabcmd k }
function wintabcmd_l { wintabcmd l }

zle -N wintabcmd_h
zle -N wintabcmd_j
zle -N wintabcmd_k
zle -N wintabcmd_l

bindkey -a "^h" wintabcmd_h
bindkey -a "^j" wintabcmd_j
bindkey -a "^k" wintabcmd_k
bindkey -a "^l" wintabcmd_l
