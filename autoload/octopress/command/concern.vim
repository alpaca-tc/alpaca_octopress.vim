let s:PM = vital#of('alpaca_octopress.vim').import('ProcessManager')

function! octopress#command#concern#open(result, ...) "{{{
  let path = ''
  let result = join([a:result[0], a:result[1]], "\n")

  for line in split(result, "\n")
    if line =~? 'Creating new \(post\|page\):'
      let path = substitute(line, '.*Creating new \(post\|page\):\s*', '', '')
      let g:path = path
      break
    endif
  endfor

  call octopress#util#open(path)
endfunction"}}}

function! octopress#command#concern#show_running_command(result, ...)
  call octopress#message#print(a:1.command . '...')
endfunction

function! octopress#command#concern#show_progress(result, ...) "{{{
  call octopress#message#print(join([a:result[0], a:result[1]], "\n"))
endfunction"}}}

function! octopress#command#concern#check_override(result, instance)
  let g:instance = a:instance
  if a:result[2] == 'timedout' && a:result[1] =~ 'mkdir -p'
    let input = octopress#util#input('Do you want to overwrite? [y/n]: ')

    if input == 'y'
      call octopress#message#print('Overrite')
      call s:PM.writeln(a:instance.pid, 'y')
    else
      call octopress#message#error('Cancel')
      call a:instance.done()
    endif
  endif
endfunction
