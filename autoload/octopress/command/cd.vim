function! octopress#command#cd#execute(options) "{{{
  if isdirectory(g:octopress#project_path)
    lcd `=g:octopress#project_path`
    call octopress#message#print('Current directory is ' . g:octopress#project_path)
  else
    call octopress#message#error('Invalid value g:octopress#project_path:' . g:octopress#project_path)
  endif
endfunction"}}}
