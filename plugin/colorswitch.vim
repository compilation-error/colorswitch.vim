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


let s:plugin_name = 'colorswitch.vim'

if !exists('g:colorswitch_dark_theme')
    let g:colorswitch_dark_theme='default'
endif

if !exists('g:colorswitch_dark_airline')
    let g:colorswitch_dark_airline='dark'
endif

if !exists('g:colorswitch_light_theme')
    let g:colorswitch_light_theme='default'
endif

if !exists('g:colorswitch_light_airline')
    let g:colorswitch_light_airline='dark'
endif


function! s:set_theme()
  let l:theme = (g:colorswitch_mode ==? 'dark') ? g:colorswitch_dark_theme : g:colorswitch_light_theme
  let l:airline = (g:colorswitch_mode ==? 'dark') ? g:colorswitch_dark_airline : g:colorswitch_light_airline

  try
    execute 'silent! colorscheme ' . l:theme
    let g:airline_theme=l:airline
  catch
    echom s:plugin_name . ': colorscheme or airline_theme missing. Using defaults.'
    colorscheme default
    let g:airline_theme='dark'
  finally
    execute 'set background=' . g:colorswitch_mode
  endtry
endfunction


function s:toggle()
  let g:colorswitch_mode = (g:colorswitch_mode ==? 'dark') ? 'light' : 'dark'
  call s:set_theme()
endfunction

function! s:set_dark()
  let g:colorswitch_mode = 'dark'
  call s:set_theme()
endfunction

function! s:set_light()
  let g:colorswitch_mode = 'light'
  call s:set_theme()
endfunction


function! s:colorswitch()
  let g:colorswitch_mode = 'dark'
  let l:os = substitute(system('uname 2>/dev/null'), '[[:cntrl:]]', '', 'g')
  if l:os ==? "Darwin"
    let l:theme = system('defaults read -g AppleInterfaceStyle >/dev/null 2>&1')
    if v:shell_error
      let g:colorswitch_mode = 'light'
    endif
  else
    try
      let l:theme = system('qdbus org.freedesktop.portal.Desktop
            \ /org/freedesktop/portal/desktop
            \ org.freedesktop.portal.Settings.Read
            \ "org.freedesktop.appearance" "color-scheme"')
      if l:theme == 2
        let g:colorswitch_mode = 'light'
      endif
    catch
      echom s:plugin_name . ': Could not detect OS mode. Ensure xdg-portal-desktop is installed.'
    endtry
  endif
  call s:set_theme()
endfunction


" User Commands
command! -nargs=0 ColorSwitchDark call s:set_dark()
command! -nargs=0 ColorSwitchLight call s:set_light()
command! -nargs=0 ColorSwitchToggle call s:toggle()

" Key Mapping
nnoremap <Plug>(ColorSwitchToggle) :<c-u>call ColorSwitchToggle()<CR>


call s:colorswitch()


let &cpo = s:cpo_save
unlet s:cpo_save

" vim: set ft=vim sw=2 et ts=2 sts=2 foldmethod=marker:
"
