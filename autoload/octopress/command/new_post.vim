function! octopress#command#new_post#execute(options) "{{{
  if len(a:options) == 0
    call octopress#message#error('Missing post_title')
    let title = octopress#util#input('Please input title: ')
  else
    let title = a:options[0]
  endif

  let command = 'new_post\[' . title . '\]'
  let callback = {
        \ 'done' : 'octopress#command#concern#open',
        \ 'in_process' : 'octopress#command#concern#check_override',
        \ }

  call octopress#system#execute(command, callback)
endfunction"}}}
