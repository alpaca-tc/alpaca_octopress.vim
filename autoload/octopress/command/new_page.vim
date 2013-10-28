function! octopress#command#new_page#execute(options) "{{{
  if len(a:options) == 0
    call octopress#message#error('Missing page_title')
    let title = octopress#util#input('Please input title: ')
  else
    let title = a:options[0]
  endif

  let command = 'new_page\[' . title . '\]'
  let callback = {
        \ 'done' : 'octopress#command#concern#open',
        \ 'in_process' : 'octopress#command#concern#show_progress',
        \ }

  call octopress#system#execute(command, callback)
endfunction"}}}
