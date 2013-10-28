function! octopress#command#cd#execute(options) "{{{
  if isdirectory(g:octopress#project_url)
    lcd `=g:octopress#project_url`
    call octopress#print_message('Current directory is ' . g:octopress#project_url)
  else
    call octopress#print_error('Invalid value g:octopress#project_url:' . g:octopress#project_url)
  endif
endfunction"}}}
