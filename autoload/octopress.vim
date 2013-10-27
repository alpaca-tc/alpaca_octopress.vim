function! octopress#system(...) "{{{
  let commands = a:000
  let command = join(commands, ' ')
  let command = g:octopress#rake_command . ' ' . command

  call octopress#print_message(command . '...')
  let result = system(command)
  call octopress#print_message(result)

  let g:huga = result
  return result
endfunction"}}}

function! octopress#complete(arg_lead, cmd_line, cursor_pos) "{{{
  if !exists('s:command_list')
    let s:command_list = [
          \ 'new_post',
          \ 'new_page',
          \ 'clean',
          \ 'deploy',
          \ 'gen_deploy',
          \ 'generate',
          \ 'push',
          \ 'rsync',
          \ ]
  endif

  return filter(copy(s:command_list), 'v:val =~ a:arg_lead')
endfunction"}}}

function! octopress#execute(task, ...) "{{{
  if a:task =~# '^\(new_post\|watch\|preview\)$'
    return octopress#{a:task}#execute(a:000)
  elseif a:task =~# '^\(generate\|deploy\|gen_deploy\|push\|rsync\|clean\|\)$'
    call octopress#system(a:task)
  elseif empty(a:task) && !empty(g:octopress#project_url)
    if isdirectory(g:octopress#project_url)
      lcd `=g:octopress#project_url`
      call octopress#print_message('Current directory is ' . g:octopress#project_url)
    else
      call octopress#print_error('Invalid value g:octopress#project_url:' . g:octopress#project_url)
    endif
  else
    call octopress#print_error("I don't know about that Octopress task.")
  endif
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
  return type(a:message) ==# type([]) ? a:message : split(a:message, '\n')
endfunction"}}}

function! octopress#print_error(message) "{{{
  let messages = s:msg2list(a:message)
  for mes in messages
    echohl WarningMsg | echomsg mes | echohl None
  endfor
endfunction"}}}
function! octopress#print_message(message) "{{{
  let message = s:msg2list(a:message)
  echohl Comment | call s:redraw_echo(message) | echohl None
endfunction"}}}
function! octopress#clear_message() "{{{
  redraw
endfunction"}}}
"}}}
