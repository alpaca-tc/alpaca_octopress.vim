function! octopress#util#input(message, ...) "{{{
  let default = len(a:000) > 0 ? a:0 : ''

  while 1
    let input = input(a:message, default)
    if !empty(input)
      return input
    endif
  endwhile
endfunction"}}}

function! octopress#util#open(path) "{{{
  let path = g:octopress#project_path . '/' . a:path

  if filereadable(path)
    execute g:octopress#open path
    doautocmd BufNewFile
    call octopress#message#print('Edit :' . path)
  else
    call octopress#message#error('Unable to find path to new page file')
  endif
endfunction"}}}
