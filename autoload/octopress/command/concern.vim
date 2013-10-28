let s:PM = vital#of('alpaca_octopress.vim').import('ProcessManager')

function! octopress#command#concern#open(result, ...) "{{{
  let path = ''

  for line in split(join([a:result[0], a:result[1]], "\n"), "\n")
    if line =~? 'Creating new \(post\|page\):'
      let path = substitute(line, '^Creating new \(post\|page\):\s*', '', '')
      break
    endif
  endfor

  call octopress#util#open(path)
endfunction"}}}

function! octopress#command#concern#show_progress(result, ...) "{{{
  call octopress#message#print(join([a:result[0], a:result[1]], "\n"))
endfunction"}}}

function! octopress#command#concern#check_override(result, instance)
  call octopress#message#error(join([a:result[0], a:result[1]]))
  " TODO
  " if join([a:result[0], a:result[1]]) =~ 'Do you want to overwrite?'
  "   let input = octopress#util#input('Do you want to overwrite? [y/n]:')
  "   call s:PM.write(instance.pid, input)
  " endif
endfunction
