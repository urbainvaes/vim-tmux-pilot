" The MIT License (MIT)
"
" Copyright (c) 2018 Urbain Vaes
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.

let s:wincmd_to_direction = {'h':'left', 'l':'right', 'j':'bottom', 'k':'top'}
let s:wincmd_to_panecmd = {'h': 'L', 'l':'R', 'j':'D', 'k':'U'}
let s:wincmd_to_tabcmd = {'h': 'tabprevious', 'l':'tabnext'}

function! wintab#wintab(wincmd)

    " Vim window
    let winnum = winnr()
    execute 'wincmd' a:wincmd
    if winnum != winnr()
        return
    endif

    " Tmux pane
    if $TMUX != ''
        let dir = get(s:wincmd_to_direction, a:wincmd)
        let nopane = system('tmux list-panes -F "#{pane_active}#{pane_at_'.dir.'}" | sed -n "s/^1\(.\)/\1/p"')
        if nopane == 0
            call system('tmux select-pane -'.get(s:wincmd_to_panecmd, a:wincmd))
            return
        endif
    endif

    if a:wincmd == 'j' || a:wincmd == 'k'
       return
    endif

    " Vim tab
    if tabpagenr() > 1 && a:wincmd == 'h'
        tabprevious | return
    elseif tabpagenr() < tabpagenr('$') && a:wincmd == 'l'
        tabnext | return
    endif

    " Tmux window
    if $TMUX != ''
        if system('tmux list-windows | wc -l') > 1
            echom system('tmux select-window -'.(a:wincmd == 'h' ? 'p' : 'n'))
        end
    endif
endfunction
