" plugin/whid.vim
if exists('g:loaded_tutorial') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

hi def link tutorialHeader      Number
hi def link tutorialSubHeader   Identifier

command! Tutorial lua require'tutorial.tutorial'.start()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_tutorial = 1
