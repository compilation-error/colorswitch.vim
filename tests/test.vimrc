
set nocompatible
syntax on
filetype plugin indent on

set runtimepath+=~/Workspace/colorswitch.vim

let g:colorswitch_dark_theme='ayu'
let g:colorswitch_dark_airline='base16'
let g:colorswitch_light_theme='ayu'
let g:colorswitch_light_airline='base16'
let g:colorswitch_light_prehook="let ayucolor='light'"
let g:colorswitch_dark_prehook="let ayucolor='mirage'"

set cmdheight=5
