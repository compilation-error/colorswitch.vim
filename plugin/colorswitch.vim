" Copyright (c) 2023 Romeet Chhabra
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.

let s:cpo_save = &cpo
set cpo&vim

let s:plugin_name = 'colorswitch'

if !exists('g:colorswitch_dark_theme')
    let g:colorswitch_dark_theme='default'
endif

if !exists('g:colorswitch_dark_airline')
    let g:colorswitch_dark_airline='simple'
endif

if !exists('g:colorswitch_light_theme')
    let g:colorswitch_light_theme='default'
endif

if !exists('g:colorswitch_light_airline')
    let g:colorswitch_light_airline='simple'
endif

function s:set_dark()
      set background=dark
      execute 'colorscheme ' . g:colorswitch_dark_theme
      let g:airline_theme=g:colorswitch_dark_airline
      let g:colorswitch_mode='dark'
endfunction

function s:set_light()
      set background=light
      execute 'colorscheme ' . g:colorswitch_light_theme
      let g:airline_theme=g:colorswitch_light_airline
      let g:colorswitch_mode='light'
endfunction

function s:toggle()
  if g:colorswitch_mode == 'dark'
    call s:set_light()
  else
    call s:set_dark()
  endif
endfunction

function! s:colorswitch()
  let l:is_dark = 1
  let l:os = substitute(system('uname 2>/dev/null'), '[[:cntrl:]]', '', 'g')
  if l:os ==? "Darwin"
    let l:theme = system('defaults read -g AppleInterfaceStyle >/dev/null 2>&1')
    if v:shell_error
      let l:is_dark = 0
    endif
  else
    " Requires xdg-portal-desktop to be installed
    let l:theme = system('qdbus org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read "org.freedesktop.appearance" "color-scheme"')
    if l:theme == 2
      let l:is_dark = 0
    endif
  endif

  if l:is_dark
    call s:set_dark()
  else
    call s:set_light()
  endif
endfunction

" User commands
command! -nargs=0 ColorSwitchDark call s:set_dark()
command! -nargs=0 ColorSwitchLight call s:set_light()
command! -nargs=0 ColorSwitchToggle call s:toggle()

nnoremap <Plug>(ColorSwitchToggle) :<c-u>call ColorSwitchToggle()<CR>

call s:colorswitch()

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: set ft=vim sw=2 et ts=2 sts=2 foldmethod=marker:
"
