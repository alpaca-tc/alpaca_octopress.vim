" octopress.vim - Wrapper for Octopress Rake commands
" Language:         Octopress (Markdown/Textile with Liquid)
" Maintainer:       Dan Lowe (dan@tangledhelix.com)
"                   IshiiHiroyuki <@alpaca-tc>
" URL:              https://github.com/alpaca-tc/vim-octopress
"
" TODO: store state of swapfile, then restore it.
" only change state if it was set previously.

if exists('g:loaded_octopress') || &cp
  finish
endif
let g:loaded_octopress = 1

let s:save_cpo = &cpo
set cpo&vim

let g:octopress_rake_executable = get(g:, 'octopress_rake_executable', 'rake')

command! -bang -nargs=* -complete=customlist,octpress#complete Octopress call octpress#execute(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
