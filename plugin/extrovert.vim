" Title:        Vim Extrovert
" Description:  A plugin to generate URLs for git files you work on
" Last Change:  29 October 2024
" Maintainer:   cd-4 <https://github.com/cd-4>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_extrovert")
    finish
endif
let g:loaded_extrovert = 1

" Exposes the plugin's functions for use as commands in Vim.
command! -nargs=0 DisplayTime call extrovert#Test()

