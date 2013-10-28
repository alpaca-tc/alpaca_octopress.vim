function! octopress#command#concern#open(result) "{{{
  let path = ''

  for line in split(join([a:result[0], a:result[1]], "\n"), "\n")
    if line =~? 'Creating new \(post\|page\):'
      let path = substitute(line, '^Creating new \(post\|page\):\s*', '', '')
      break
    endif
  endfor

  call octopress#util#open(path)
endfunction"}}}

function! octopress#command#concern#show_progress(result) "{{{
  call octopress#message#print(join([a:result[0], a:result[1]], "\n"))
endfunction"}}}
