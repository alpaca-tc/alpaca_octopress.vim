" if (exists("b:did_ftplugin"))
"   finish
" endif
" let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim


if expand('%:p') =~ '_posts/.*\.markdown'
  let s:source_dir = expand('%:p:h:h')
  let s:include_dir = expand('%:p:h:h') . '/_include'
  " Octopress
  execute 'setlocal path+=' . s:source_dir
  execute 'setlocal path+=' . s:include_dir

  set include=\({%\(\s\+\w\+\)\+\(\s*\|\s\+[a-zA-Z0-9_#\?\!]\+\)\@=\|{{\(\s\+\w\+\)\+\(\s*\|\s\+[a-zA-Z0-9_#\?\!]\+\)\@=\)
  set includeexpr=substitute(v:fname,'^/','','g')

  let b:undo_ftplugin="setl include< includeexpr< path<"
endif

let &cpo = s:cpo_save
unlet s:cpo_save
