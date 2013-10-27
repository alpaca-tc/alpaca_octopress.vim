function! octopress#new_page#execute(options)
  if len(a:options) == 0
    echoerr 'Missing page_title'
    return
  else
    let title = a:options[0]
  endif

  let rake_output = octopress#system('new_page\[' . title . '\]')
  let page_path = ''

  for line in split(rake_output, "\n")
    if line =~? 'Creating new page:'
      let page_path = substitute(line, '^Creating new page:\s*', '', '')
      break
    endif
  endfor

  if filereadable(page_path)
    edit `=page_path`
    call octopress#print_message('Edit ' . page_path)
  else
    call octopress#print_error('Unable to find path to new page file')
  endif
endfunction
