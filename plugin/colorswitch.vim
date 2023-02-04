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
let g:loaded_colorswitch=1

let s:cpo_save = &cpo
set cpo&vim

let s:plugin_name = 'colorswitch'

" User Commands
command! -nargs=0 ColorSwitchDark   call colorswitch#set_manual() | call colorswitch#set_dark()
command! -nargs=0 ColorSwitchLight  call colorswitch#set_manual() | call colorswitch#set_light()
command! -nargs=0 ColorSwitchToggle call colorswitch#set_manual() | call colorswitch#toggle()
command! -nargs=0 ColorSwitchAuto   call colorswitch#set_auto()   | call colorswitch#set_auto()
command! -nargs=0 ColorSwitchJobStatus call colorswitch#job_stat()
" Key Mapping
nnoremap <Plug>(ColorSwitchToggle) :<c-u>call ColorSwitchToggle()<CR>

call colorswitch#init()

let &cpo = s:cpo_save
unlet s:cpo_save


" vim: set ft=vim sw=2 et ts=2 sts=2 foldmethod=marker:
"
