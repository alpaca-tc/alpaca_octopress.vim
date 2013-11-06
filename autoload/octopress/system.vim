let s:P  = vital#of('alpaca_octopress.vim').import('Process')

function! s:build_command(command_and_callback) "{{{
  let commands = []
  let callback = {}

  for option in a:command_and_callback
    if type(option) == type([])
      call extend(commands, option)
    elseif type(option) == type('')
      call add(commands, option)
    elseif type(option) == type({})
      call extend(callback, option)
    endif
    unlet option
  endfor

  let command = g:octopress#rake_command . ' ' . join(commands, ' ')

  return [command, callback]
endfunction"}}}

function! octopress#system#execute(...) "{{{
  let [command, callback] = s:build_command(a:000)

  if s:P.has_vimproc() && g:octopress#system#async == 1
    return octopress#system#asynchronous#new(command, callback)
  else
    return octopress#system#synchronous#new(command, callback)
  endif
endfunction"}}}
