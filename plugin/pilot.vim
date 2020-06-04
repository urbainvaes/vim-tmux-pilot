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

if exists('g:loaded_pilot') || &compatible
    finish
endif
let g:loaded_pilot = 1

let s:default_keys = {
      \ "h": '<c-h>',
      \ "j": '<c-j>',
      \ "k": '<c-k>',
      \ "l": '<c-l>',
      \ "p": '<c-\>'}

function! s:get_key(key)
  return get(g:, "pilot_key_".a:key, s:default_keys[a:key])
endfunction

function! Pilot_on()
  exe "nnoremap <silent>" s:get_key('h') ":call pilot#wintabcmd('h')\<cr>"
  exe "nnoremap <silent>" s:get_key('j') ":call pilot#wintabcmd('j')\<cr>"
  exe "nnoremap <silent>" s:get_key('k') ":call pilot#wintabcmd('k')\<cr>"
  exe "nnoremap <silent>" s:get_key('l') ":call pilot#wintabcmd('l')\<cr>"
  exe "nnoremap <silent>" s:get_key('p') ":call pilot#wintabcmd('p')\<cr>"

  if has("nvim")
    exe "tnoremap <silent>" s:get_key('h') "\<c-\>\<c-n>:call pilot#terminal('h')\<cr>"
    exe "tnoremap <silent>" s:get_key('j') "\<c-\>\<c-n>:call pilot#terminal('j')\<cr>"
    exe "tnoremap <silent>" s:get_key('k') "\<c-\>\<c-n>:call pilot#terminal('k')\<cr>"
    exe "tnoremap <silent>" s:get_key('l') "\<c-\>\<c-n>:call pilot#terminal('l')\<cr>"
  elseif exists("+termwinkey")
    let twk = &twk == "" ? "<c-w>" : &twk
    exe "tnoremap <silent>" s:get_key('h') twk.":call pilot#terminal('h')\<cr>"
    exe "tnoremap <silent>" s:get_key('j') twk.":call pilot#terminal('j')\<cr>"
    exe "tnoremap <silent>" s:get_key('k') twk.":call pilot#terminal('k')\<cr>"
    exe "tnoremap <silent>" s:get_key('l') twk.":call pilot#terminal('l')\<cr>"
  endif

  let s:on = 1
  echom "vim-tmux-pilot status: on"
endfunction

function! Pilot_off()
  exe "nunmap" s:get_key('h')
  exe "nunmap" s:get_key('j')
  exe "nunmap" s:get_key('k')
  exe "nunmap" s:get_key('l')
  exe "nunmap" s:get_key('p')

  if has("nvim") || exists("+termwinkey")
    exe "tunmap <silent>" s:get_key('h')
    exe "tunmap <silent>" s:get_key('j')
    exe "tunmap <silent>" s:get_key('k')
    exe "tunmap <silent>" s:get_key('l')
  endif

  let s:on = 0
  echom "vim-tmux-pilot status: off"
endfunction

function! Pilot_toggle()
  call function(s:on ? "Pilot_off" : "Pilot_on")()
endfunction

command! -nargs=0 PilotToggle call Pilot_toggle()
command! -nargs=1 Pilotcmd call pilot#wintabcmd(<f-args>)

silent call Pilot_on()

" vim: sw=2
