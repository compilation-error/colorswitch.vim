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

if exists('g:loaded_colorswtich')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim


let s:plugin_name = 'colorswitch'

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

if !exists('g:colorswitch_mode')
  let g:colorswitch_mode='dark'
endif

if !exists('g:colorswitch_autoswitch')
  let g:colorswitch_autoswitch=0
endif


function s:init()
  let s:platform = ''

  if has('mac')
    let s:platform = 'macos'
  elseif has('linux')
    let s:platform = 'linux'
  " elseif has('gui_mac')
  "  let s:platform('macvim')
  endif

  echom s:plugin_name . ": Identified platform " . s:platform
  let s:get_os_mode = function("s:get_os_mode_" . s:platform)

  call s:colorswitch()
  call s:set_theme()
  if g:colorswitch_autoswitch == 1
    call s:set_auto()
  endif
endfunction


function! s:colorswitch()
  let l:os_mode = s:get_os_mode()
  if l:os_mode != g:colorswitch_mode
    let g:colorswitch_mode = l:os_mode
    call s:set_theme()
  endif
endfunction


function! s:set_theme()
  let l:theme = (g:colorswitch_mode == 'dark') ? g:colorswitch_dark_theme : g:colorswitch_light_theme
  let l:airline = (g:colorswitch_mode == 'dark') ? g:colorswitch_dark_airline : g:colorswitch_light_airline

  echom s:plugin_name . ": Setting theme " . g:colorswitch_mode . "( " . l:theme . ", " . l:airline . " )"

  try
    execute 'silent! colorscheme ' . l:theme
    let g:airline_theme = l:airline
  catch
    echoe s:plugin_name . ': colorscheme or airline_theme missing. Using defaults.'
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


function! s:get_os_mode_macos()
  let l:os_mode = 'dark'
  let l:theme = system('defaults read -g AppleInterfaceStyle >/dev/null 2>&1')
  if v:shell_error
    let l:os_mode = 'light'
  endif
  return l:os_mode
endfunction

function! s:get_os_mode_linux()
  let l:os_mode = 'dark'
  try
    let l:theme = system('qdbus org.freedesktop.portal.Desktop
          \ /org/freedesktop/portal/desktop
          \ org.freedesktop.portal.Settings.Read
          \ "org.freedesktop.appearance" "color-scheme"')
    if l:theme == 2
      let l:os_mode = 'light'
    endif
  catch
    echoe s:plugin_name . ': Could not detect OS mode. Ensure xdg-portal-desktop is installed.'
  endtry
  return l:os_mode
endfunction


function! s:timed_autoswitch(timer)
  call s:colorswitch()
endfunction

function s:callback_handler(channel, message)
  echom a:channel . "->" . a:message
endfunction


function! s:set_auto()
  if exists('s:watcher') && s:job_stat() ==? 'run'
    return
  endif

  if !has('job')
    echoe s:plugin_name . ": No support for Jobs. Can not run in auto mode."
    return
  endif

  let options = {'out_cb': function('s:callback_handler')}
  let s:watcher = job_start("watch -t -n600 'defaults read -g AppleInterfaceStyle'", options)
  echom "Job Status: " . job_status(s:watcher)
endfunction

function! s:job_stat()
  if !exists('s:watcher')
    finish
  endif

  let l:job_stat = job_status(s:watcher)
  echom "Job Status: " . l:job_stat
  echom job_info(s:watcher)
  return l:job_stat
endfunction

function! s:set_manual()
  let g:colorswitch_autoswitch = 0
  if exists('s:watcher')
    call job_stop(s:watcher)
  endif
endfunction


" User Commands
command! -nargs=0 ColorSwitchDark   call s:set_manual() | call s:set_dark()
command! -nargs=0 ColorSwitchLight  call s:set_manual() | call s:set_light()
command! -nargs=0 ColorSwitchToggle call s:set_manual() | call s:toggle()
command! -nargs=0 ColorSwitchAuto   call s:set_auto()   | call s:set_auto()
command! -nargs=0 ColorSwitchJobStatus call s:job_stat()

" Key Mapping
nnoremap <Plug>(ColorSwitchToggle) :<c-u>call ColorSwitchToggle()<CR>


call s:init()


let &cpo = s:cpo_save
unlet s:cpo_save

let g:loaded_colorswitch=1

" vim: set ft=vim sw=2 et ts=2 sts=2 foldmethod=marker:
"
