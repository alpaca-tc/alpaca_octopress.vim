function! octpress#system(...) "{{{
  let commands = a:000
  let command = join(commands, ' ')
  let command = g:octopress_rake_executable . ' ' . command

  echomsg command . '...'
  return system(command)
endfunction"}}}

function! octpress#complete(arg_lead, cmd_line, cursor_pos) "{{{
  if !exists('s:command_list')
    let s:command_list = [
          \ 'new_post',
          \ 'new_page',
          \ 'clean',
          \ 'deploy',
          \ 'gen_deploy',
          \ 'generate',
          \ 'push',
          \ 'rsync'
          \ ]
  endif

  return filter(copy(s:command_list), 'v:val =~ a:arg_lead')
endfunction"}}}

function! octpress#execute(task, ...) "{{{
  redraw!

  if a:task =~# '^\(new_post\|watch\|preview\)$'
    return octpress#{a:task}#execute(a:000)
  elseif a:task =~# '^\(generate\|deploy\|gen_deploy\|push\|rsync\|clean\|\)$'
    " if a:task =~# '^\(deploy\|gen_deploy\|rsync\)$'
    "   set noswapfile
    " endif

    let result = octpress#system(a:task)
    for message in split(result, '\n')
      echomsg message
    endfor
  else
    echo "I don't know about that Octopress task."
  endif

  redraw!
endfunction"}}}
