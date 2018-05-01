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

let s:default_precedence = 'tsplit'
let s:default_mode = 'winonly'
let s:default_boundary = 'ignore'
let s:path = expand('<sfile>:p:h')

function! s:get_tmux_cmd(cmd)
  if $TMUX == ""
    return ""
  elseif s:tmux_cmd == ""
    let argument = a:cmd . " dry"
    let script = s:path . "/../sh/tmux-wintabcmd"
    let s:tmux_cmd = system('sh '.script." ".a:cmd." dry")
  endif
  return s:tmux_cmd
endfunction

function! wintab#wintab(cmd)

  let precedence = get(g:, 'wintab_precedence', s:default_precedence)
  let mode = get(g:, 'wintab_mode', s:default_mode)
  let boundary = get(g:, 'wintab_boundary', s:default_boundary)
  let s:tmux_cmd=""

  if precedence == 'vtab'
    let order = ['vsplit', 'vtab', 'tsplit', 'ttab']
  else
    let order = ['vsplit', 'tsplit', 'vtab', 'ttab']
  endif

  for elem in order

    " Vim window
    if elem == 'vsplit'
      let winnum = winnr()
      execute 'wincmd' a:cmd
      if winnum != winnr()
        return
      endif

    " Tmux pane
    elseif elem == 'tsplit' && s:get_tmux_cmd(a:cmd) =~ "select-pane"
      call system(s:tmux_cmd) | return

    " Vim tab
    elseif mode == 'wintab' && elem == 'vtab'
      if tabpagenr() > 1 && a:cmd == 'h'
        tabprevious | return
      elseif tabpagenr() < tabpagenr('$') && a:cmd == 'l'
        tabnext | return
      endif

    " Tmux window
    elseif elem == 'twin' && s:get_tmux_cmd(a:cmd) =~ "select-window"
      call system(s:tmux_cmd) | return
    endif

  endfor

  " Will always create tmux-pane before vim-tab!
  " Zoom!
  if s:tmux_cmd != "" && s:tmux_cmd !~ "send-keys"
    call system(s:tmux_cmd) | return
  endif

  if boundary == 'create'
    if a:cmd == 'j'
      rightbelow new
    elseif a:cmd == 'k'
      leftabove new
    endif

    if mode == 'winonly'
      if a:cmd == 'h'
        leftabove vnew
      elseif a:cmd == 'l'
        rightbelow vnew
      endif

    elseif mode == 'wintab'
      if a:cmd == 'h'
        tabnew
        tabmove 0
      elseif a:cmd == 'l'
        tabnew
      endif
    endif

  elseif boundary == 'reflect'
    if a:cmd == 'j'
      5wincmd k
    elseif a:cmd == 'k'
      5wincmd j
    endif

    if mode == 'wintab' &&  tabpagenr('$') > 1
      if a:cmd == 'h'
        tabprevious
      elseif a:cmd == 'l'
        tabnext
      endif

    else
      if a:cmd == 'h'
        5wincmd l
      elseif a:cmd == 'l'
        5wincmd h
      endif
    endif

  elseif boundary == 'ignore'
    call feedkeys("\<c-".a:cmd, 'n')
  endif

endfunction

" vim: sw=2
