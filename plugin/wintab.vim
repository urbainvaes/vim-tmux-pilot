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

function! s:insert()
  norm a
  augroup wintab
    autocmd! BufEnter <buffer>
  augroup END
endfunction

let s:count = 0
function! wintab#terminal(wincmd)
  " ps -o state= -o comm= -t '#{pane_tty}' \
  "     | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?(g?(view|n?vim?x?)(diff)?|fzf)$'
  let s:count =  s:count + 1
  augroup wintab
    autocmd!
    autocmd BufEnter <buffer> call s:insert()
  augroup END
  call wintab#wintab(a:wincmd)
endfunction

function! wintab#on()
  nnoremap <silent> <c-h> :call wintab#wintab('h')<cr>
  nnoremap <silent> <c-j> :call wintab#wintab('j')<cr>
  nnoremap <silent> <c-k> :call wintab#wintab('k')<cr>
  nnoremap <silent> <c-l> :call wintab#wintab('l')<cr>

  if has("nvim")
    tnoremap <silent> <c-h> <c-\><c-n>:call wintab#terminal('h')<cr>
    tnoremap <silent> <c-j> <c-\><c-n>:call wintab#terminal('j')<cr>
    tnoremap <silent> <c-k> <c-\><c-n>:call wintab#terminal('k')<cr>
    tnoremap <silent> <c-l> <c-\><c-n>:call wintab#terminal('l')<cr>
  endif

  let s:on = 1
  echom "Wintab status: on"
endfunction

function! wintab#off()
  nunmap <c-h>
  nunmap <c-l>
  nunmap <c-j>
  nunmap <c-k>

  if has("nvim")
    tunmap <silent> <c-h>
    tunmap <silent> <c-j>
    tunmap <silent> <c-k>
    tunmap <silent> <c-l>
  endif

  let s:on = 0
  echom "Wintab status: off"
endfunction

function! wintab#toggle()
  call function(s:on ? "wintab#off" : "wintab#on")()
endfunction

command! -nargs=0 WintabToggle call wintab#toggle()
command! -nargs=1 Wintabcmd call wintab#wintab(<f-args>)

silent call wintab#on()

" vim: sw=2
