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


function! colorswitch#declare_globals()
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

  if !exists('g:colorswitch_light_prehook')
    let g:colorswitch_light_prehook=""
  endif

  if !exists('g:colorswitch_light_posthook')
    let g:colorswitch_light_posthook=""
  endif

  if !exists('g:colorswitch_dark_prehook')
    let g:colorswitch_dark_prehook=""
  endif

  if !exists('g:colorswitch_dark_posthook')
    let g:colorswitch_dark_posthook=""
  endif

  if !exists('g:colorswitch_autoswitch')
    let g:colorswitch_autoswitch=0
  endif
endfunction

function colorswitch#init()
  let s:platform = ''

  if has('mac')
    let s:platform = 'macos'
  elseif has('linux')
    let s:platform = 'linux'
    " elseif has('gui_mac')
    "  let s:platform('macvim')
  endif

  if s:platform == ''
    finish
  endif

  call colorswitch#declare_globals()

  " echom s:plugin_name . ": Identified platform " . s:platform
  let s:get_os_mode = function("colorswitch#get_os_mode_" . s:platform)
  let s:pid = getpid()

  call colorswitch#colorswitch()

  if g:colorswitch_autoswitch == 1
    call colorswitch#set_auto()
  endif
endfunction


function! colorswitch#colorswitch()
  let g:colorswitch_mode = s:get_os_mode()
  call colorswitch#set_theme()
endfunction


function! colorswitch#set_theme()
  let l:theme = (g:colorswitch_mode == 'dark') ? g:colorswitch_dark_theme : g:colorswitch_light_theme
  let l:airline = (g:colorswitch_mode == 'dark') ? g:colorswitch_dark_airline : g:colorswitch_light_airline
  let l:prehook = (g:colorswitch_mode == 'dark') ? g:colorswitch_dark_prehook : g:colorswitch_light_prehook
  let l:posthook = (g:colorswitch_mode == 'dark') ? g:colorswitch_dark_posthook : g:colorswitch_light_posthook

  " echo s:plugin_name . ": Setting theme " . g:colorswitch_mode . "( " . l:theme . ", " . l:airline . " )"
  try
    execute l:prehook
    execute 'silent! colorscheme ' . l:theme
    let g:airline_theme = l:airline
    execute l:posthook
  catch
    echoe s:plugin_name . ': colorscheme or airline_theme missing. Using defaults.'
    colorscheme default
    let g:airline_theme='dark'
  finally
    execute 'set background=' . g:colorswitch_mode
  endtry
endfunction


function colorswitch#toggle()
  let g:colorswitch_mode = (g:colorswitch_mode ==? 'dark') ? 'light' : 'dark'
  call colorswitch#set_theme()
endfunction

function! colorswitch#set_dark()
  let g:colorswitch_mode = 'dark'
  call colorswitch#set_theme()
endfunction

function! colorswitch#set_light()
  let g:colorswitch_mode = 'light'
  call colorswitch#set_theme()
endfunction


function! colorswitch#get_os_mode_macos()
  let l:os_mode = 'dark'
  let l:theme = system('defaults read -g AppleInterfaceStyle >/dev/null 2>&1')
  if v:shell_error
    let l:os_mode = 'light'
  endif
  return l:os_mode
endfunction

function! colorswitch#get_os_mode_linux()
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


function colorswitch#callback_handler(channel, message)
  " echom a:channel . "->" . a:message
endfunction

function! colorswitch#set_auto()
  if exists('s:watcher') && colorswitch#job_stat() ==? 'run'
    return
  endif

  if !has('job')
    echoe s:plugin_name . ": No support for Jobs. Can not run in auto mode."
    return
  endif

  augroup auto_mode
    autocmd!
    " autocmd sigUSR1 * echo "Recieved OS SIGUSR1 from watcher.sh"
    autocmd sigUSR1 * call colorswitch#colorswitch()
  augroup END

  let job_cmd = "sh " . resolve(expand('<sfile>:p:h')) . "/" . s:platform . "_watch.sh " . s:pid
  let options = {'callback': function('colorswitch#callback_handler')}
  let s:watcher = job_start(job_cmd, options)
  " echom "Job Status: " . job_info(s:watcher)
endfunction

function! colorswitch#job_stat()
  if !exists('s:watcher')
    return
  endif

  let l:job_stat = job_status(s:watcher)
  echom job_info(s:watcher)
  return l:job_stat
endfunction

function! colorswitch#set_manual()
  if exists('s:watcher')
    call job_stop(s:watcher)
  endif
endfunction

" vim: set ft=vim sw=2 et ts=2 sts=2 foldmethod=marker:
"
