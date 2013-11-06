function! octopress#command#cd#execute(options) "{{{
  if isdirectory(g:octopress#project_path)
    lcd `=g:octopress#project_path`
    call octopress#print_message('Current directory is ' . g:octopress#project_path)
  else
    call octopress#print_error('Invalid value g:octopress#project_path:' . g:octopress#project_path)
  endif
endfunction"}}}
