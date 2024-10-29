
" script encoding
scriptencoding utf-8

" load control
if !exists('g:loaded_vim_extrovert')
    finish
endif

let g:loaded_vim_extrovert = 1

let s:save_cpo = &cpo
set cpo&vim

function! extrovert#Test()
    echom "TEST"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
