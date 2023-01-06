# colorswitch.vim

Plugin to automatically set dark and light colorschemes based on OS mode.
Sets background and colorscheme as well as airline theme.

Currently works for MacOS and linux (KDE) only.

## Requirements
### On KDE
[xdg-portal-desktop](https://github.com/KDE/xdg-desktop-portal-kde)

### Optional
[vim-airline](https://github.com/vim-airline/vim-airline)

[vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)

## Installation
Using [vim-plug](https://github.com/junegunn/vim-plug)
```
Plug 'compilation-error/colorswitch.vim'
```
## Usage
Set the following in your `.vimrc`
```
let g:colorswitch_dark_theme='default'
let g:colorswitch_dark_airline='dark'
let g:colorswitch_light_theme='default'
let g:colorswitch_light_airline='dark'
```
Automatic switching based on OS model when Vim starts.

Manually call `ColorSwitchDark`, `ColorSwitchLight`, or `ColorSwitchToggle` to switch to dark, light modes or toggle mode, respectively.

## Licence
MIT
