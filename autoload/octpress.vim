function! octpress#system(...) "{{{
  let commands = a:000
  let command = join(commands, ' ')
  let command = g:octopress#rake_command . ' ' . command

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

" Print message "{{{
function! s:redraw_echo(expr) "{{{
  if has('vim_starting')
    echo join(s:msg2list(a:expr), "\n")
    return
  endif

  let msg = s:msg2list(a:expr)
  let height = max([1, &cmdheight])
  for i in range(0, len(msg)-1, height)
    redraw
    echo join(msg[i : i+height-1], "\n")
  endfor
endfunction"}}}
function! s:msg2list(message) "{{{
  return type(a:expr) ==# type([]) ? a:expr : split(a:expr, '\n')
endfunction"}}}

function! octpress#print_error(message) "{{{
  let messages = s:msg2list(a:message)
  for mes in messages
    echohl WarningMsg | echomsg mes | echohl None
  endfor
endfunction"}}}
function! octpress#print_message(message) "{{{
  let message = s:msg2list(a:message)
  echohl Comment | call s:redraw_echo(message) | echohl None
endfunction"}}}
function! octpress#clear_message() "{{{
  redraw
endfunction"}}}
"}}}
