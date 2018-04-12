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

let g:wintab_mode = get(g:, 'wintab_mode', 'wintab')

let s:path = expand('<sfile>:p:h')
let s:wincmd_to_direction = {'h':'left', 'l':'right', 'j':'bottom', 'k':'top'}
let s:wincmd_to_panecmd = {'h': 'L', 'l':'R', 'j':'D', 'k':'U'}
let s:wincmd_to_tabcmd = {'h': 'tabprevious', 'l':'tabnext'}

function! s:order()
    if exists("g:wintab_order")
        return g:wintab_order
    elseif g:wintab_mode == 'win'
        return ['vwin', 'tpane']
    elseif g:wintab_mode == 'wintab'
        return ['vwin', 'vtab', 'tpane', 'twin']
    endif
endfunction

function! wintab#wintab(wincmd)
    if s:order != s:order() | silent call wintab#on() | endif
    for elem in s:order()
        if elem == 'vwin' " Vim window
            let winnum = winnr()
            execute 'wincmd' a:wincmd
            if winnum != winnr()
                return
            endif
        elseif elem == 'tpane' " Tmux pane
            if $TMUX != ''
                if system('tmux run "echo #{pane_at_'.get(s:wincmd_to_direction, a:wincmd).'}"') =~ '0'
                    call system('tmux select-pane -'.get(s:wincmd_to_panecmd, a:wincmd))
                    return
                endif
            endif
        elseif elem == 'vtab' " Vim tab
            if tabpagenr() > 1 && a:wincmd == 'h'
                tabprevious | return
            elseif tabpagenr() < tabpagenr('$') && a:wincmd == 'l'
                tabnext | return
            endif
        elseif elem == 'twin' " Tmux window
            if $TMUX != ''
                let iwin = system('tmux run "echo #{window_index}"')
                let nwin = system('tmux run "echo #{session_windows}"')
                if (a:wincmd == 'l' && iwin + 1 < nwin) || (a:wincmd == 'h' && iwin > 0)
                    call system('tmux select-window -'.(a:wincmd == 'h' ? 'p' : 'n'))
                end
            endif
        endif
    endfor
endfunction

function! wintab#toggle()
  call function(s:wintab_on ? "wintab#off" : "wintab#on")()
endfunction

function! wintab#toggleMode()
    if exists("g:wintab_order") | return | endif
    let g:wintab_mode = (g:wintab_mode == 'wintab' ? 'win' : 'wintab')
    call wintab#on()
endfunction

function! wintab#on()
    let s:order = s:order()
    nnoremap <silent> <Plug>(wintab-left)  :call wintab#wintab('h')<cr>
    nnoremap <silent> <Plug>(wintab-down)  :call wintab#wintab('j')<cr>
    nnoremap <silent> <Plug>(wintab-up)    :call wintab#wintab('k')<cr>
    nnoremap <silent> <Plug>(wintab-right) :call wintab#wintab('l')<cr>
    if $TMUX != ''
        if index(s:order, 'tpane') >= 0 && index(s:order, 'twin') >= 0
            call system("tmux source-file ".s:path."/../tmux/wintab.conf")
        elseif index(s:order, 'tpane') >= 0
            call system("tmux source-file ".s:path."/../tmux/win.conf")
        elseif index(s:order, 'twin') >= 0
            call system("tmux source-file ".s:path."/../tmux/tab.conf")
        endif
    endif
    let s:on = 1
    echom "Wintab status: on, in ".g:wintab_mode." mode"
endfunction

function! wintab#off()
    nunmap <c-h>
    nunmap <c-l>
    nunmap <c-j>
    nunmap <c-k>
    if $TMUX != ''
        call system("tmux source-file ".s:path."/../tmux/disable.conf")
    endif
    let s:on = 0
    echom "Wintab status: off"
endfunction

command! -nargs=0 WintabToggle call wintab#toggle()
command! -nargs=0 WintabToggleMode call wintab#toggleMode()

if get(g:, "wintab_maps", 1) == 1
    nmap <c-h> <Plug>(wintab-left) 
    nmap <c-j> <Plug>(wintab-down) 
    nmap <c-k> <Plug>(wintab-up)   
    nmap <c-l> <Plug>(wintab-right)
endif

silent call wintab#on()
