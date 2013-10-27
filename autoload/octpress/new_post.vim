function! octpress#new_post#execute(options) "{{{
  if len(a:options) == 0
    echoerr 'Missing post_title'
    return
  else
    let title = a:options[0]
  endif

  let rake_output = octpress#system('new_post\[' . title . '\]')
  let post_path = ''

  for line in split(rake_output, "\n")
    if line =~? 'Creating new post:'
      let post_path = substitute(line, '^Creating new post:\s*', '', '')
      break
    endif
  endfor

  if filereadable(post_path)
    edit `=post_path`
  else
    echoerr 'Unable to find path to new post file'
  endif
endfunction"}}}
