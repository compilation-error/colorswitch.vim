# ColorSwitch

Plugin to automatically set dark and light colorschemes based on OS mode.
Sets background and colorscheme as well as airline theme.

Currently works for MacOS and linux (KDE) only.

## Requirements
[vim-airline](https://github.com/vim-airline/vim-airline)
[vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)

### On KDE
[xdg-portal-desktop](https://github.com/KDE/xdg-desktop-portal-kde)

## Installation
Using [vim-plug](https://github.com/junegunn/vim-plug)

`Plug 'compilation-error/colorswitch'`

`Plug 'https://gitlab.com/compilation-error/colorswitch.vim.git'`

## Usage
Set the following in your `.vimrc`
```
let g:colorswitch_dark_theme='<dark_vim_colorscheme>'
let g:colorswitch_dark_airline='<dark_airline_theme>'
let g:colorswitch_light_theme='<light_vim_colorscheme>'
let g:colorswitch_light_airline='<light_airline_theme>'

```
These are set to `default` and `simple` for vim and airline themes, respectively.

Automatic Switching when Vim starts.
Manually call `ColorSwitchDark`, `ColorSwitchLight`, or `ColorSwitchToggle` to switch to dark, light modes or toggle mode, respectively.

## Licence
MIT
