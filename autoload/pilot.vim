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
let s:last_split_is_tmux = 0

let s:default_keys = {
      \ "h": '<c-h>',
      \ "j": '<c-j>',
      \ "k": '<c-k>',
      \ "l": '<c-l>',
      \ "p": '<c-\>'}

function! s:get_key(key)
  return get(g:, "pilot_key_".a:key, s:default_keys[a:key])
endfunction

function! s:get_tmux_cmd(cmd)
  if $TMUX == ""
    return ""
  elseif s:tmux_cmd == ""
    let argument = a:cmd . " dry"
    let script = s:path . "/../sh/tmux-wintabcmd"
    let s:tmux_cmd = system('sh "'.script.'" '.a:cmd.' dry')
  endif
  return s:tmux_cmd
endfunction

function! s:vim_boundary(cmd, mode, boundary)
  if a:boundary == 'create'
    if a:cmd == 'j'
      return "rightbelow new"
    elseif a:cmd == 'k'
      return "leftabove new"
    endif

    if a:mode == 'winonly'
      if a:cmd == 'h'
        return "leftabove vnew"
      elseif a:cmd == 'l'
        return "rightbelow vnew"
      endif

    elseif a:mode == 'wintab'
      if a:cmd == 'h'
        return "tabnew | tabmove 0"
      elseif a:cmd == 'l'
        return "tabnew"
      endif
    endif

  elseif a:boundary == 'reflect'
    if a:cmd == 'j'
      return "5wincmd k"
    elseif a:cmd == 'k'
      return "5wincmd j"
    endif

    if a:mode == 'wintab' &&  tabpagenr('$') > 1
      if a:cmd == 'h'
        return "tabprevious"
      elseif a:cmd == 'l'
        return "tabnext"
      endif

    else
      if a:cmd == 'h'
        return "5wincmd l"
      elseif a:cmd == 'l'
        return "5wincmd h"
      endif
    endif
  endif
  return ""
endfunction

function! pilot#wintabcmd(...)

  echom s:last_split_is_tmux
  let cmd = a:1
  let in_terminal = a:0 > 1 ? 1 : 0
  let s:tmux_cmd=""

  if cmd == 'p'
    let order = s:last_split_is_tmux ?
          \  ['tsplit', 'vsplit'] : ['vsplit', 'tsplit']
    for type in order
      if type == 'vsplit'
        let winnum = winnr()
        execute 'wincmd' cmd
        if winnum != winnr()
          let s:last_split_is_tmux = 0
          return
        endif
      elseif type == 'tsplit' && s:get_tmux_cmd(cmd) =~ "select-pane"
        call system(s:tmux_cmd)
        let s:last_split_is_tmux = 1
        return
      endif
    endfor
    return
  endif

  let precedence = get(g:, 'pilot_precedence', s:default_precedence)
  let mode = get(g:, 'pilot_mode', s:default_mode)
  let boundary = get(g:, 'pilot_boundary', s:default_boundary)

  if precedence == 'vtab'
    let order = ['vsplit', 'vtab', 'tsplit', 'ttab']
  else
    let order = ['vsplit', 'tsplit', 'vtab', 'ttab']
  endif

  for type in order

    if type == 'vsplit'
      let winnum = winnr()
      execute 'wincmd' cmd
      if winnum != winnr()
        let s:last_split_is_tmux = 0
        return
      endif

    elseif type == 'tsplit' && s:get_tmux_cmd(cmd) =~ "select-pane"
      call system(s:tmux_cmd)
      let s:last_split_is_tmux = 1
      return

    elseif mode == 'wintab' && type == 'vtab'
      if tabpagenr() > 1 && cmd == 'h'
        tabprevious | return
      elseif tabpagenr() < tabpagenr('$') && cmd == 'l'
        tabnext | return
      endif

    elseif type == 'ttab' && s:get_tmux_cmd(cmd) =~ "select-window"
      call system(s:tmux_cmd) | return
    endif

  endfor

  let vim_cmd = s:vim_boundary(cmd, mode, boundary)
  for type in reverse(order)

    if type == 'ttab'
      if s:tmux_cmd =~ "new-window"
        call system(s:tmux_cmd)
        return
      endif

    elseif type == 'vtab'
      if vim_cmd =~ "\<tab"
        execute vim_cmd
        return
      endif

    elseif type == 'tsplit'
      if s:tmux_cmd != "" && s:tmux_cmd !~ "send-keys"
        call system(s:tmux_cmd)
        let s:last_split_is_tmux = 1
        return
      endif

    elseif type == 'vsplit'
      if vim_cmd != ""
        execute vim_cmd
        let s:last_split_is_tmux = 0
      elseif in_terminal
        " Hack from [1]
        let litteral_cmd = eval('"'.escape(s:get_key(cmd), '<').'"')
        call feedkeys("i" . litteral_cmd, 'n')
      endif
    endif
  endfor
endfunction

function! s:insert()
  call feedkeys('a', 'n')
  augroup pilot
    autocmd! BufEnter <buffer>
  augroup END
endfunction

function! pilot#terminal(cmd)
  if bufname('') =~ '/bin/fzf'
    " Hack from [1]
    let litteral_cmd = eval('"'.escape(s:get_key(a:cmd), '\<').'"')
    echom litteral_cmd
    call feedkeys("i" . litteral_cmd, 'n')
    return
  endif
  augroup pilot
    autocmd!
    autocmd BufEnter <buffer> call s:insert()
  augroup END
  call pilot#wintabcmd(a:cmd, "terminal")
endfunction

" [1]:  https://vi.stackexchange.com/questions/16153/get-literal-character-from-printable-character
" vim: sw=2
