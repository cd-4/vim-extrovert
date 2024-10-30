" Title:        Vim Extrovert
" Description:  A plugin to generate URLs for git files you work on
" Last Change:  29 October 2024
" Maintainer:   cd-4 <https://github.com/cd-4>

scriptencoding utf-8

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_vim_extrovert")
    finish
endif
let g:loaded_vim_extrovert = 1

" evacuate user setting temporarily
let s:save_cpo = &cpo
set cpo&vim

" Exported Functions
command! -nargs=0 CopyGitUrl call extrovert#CopyGitUrl()
command! -nargs=0 CopyGitFileUrl call extrovert#CopyGitFileUrl()
command! -nargs=0 OpenGitUrl call extrovert#OpenGitUrl()
command! -nargs=0 OpenGitFileUrl call extrovert#OpenGitFileUrl()

" restore user setting
let &cpo = s:save_cpo
unlet s:save_cpo


