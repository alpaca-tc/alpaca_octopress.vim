let s:command_list = [
      \ 'new_post',
      \ 'new_page',
      \ 'clean',
      \ 'deploy',
      \ 'gen_deploy',
      \ 'generate',
      \ 'push',
      \ 'rsync',
      \ 'cd',
      \ ]

function! octopress#complete(arg_lead, cmd_line, cursor_pos) "{{{
  return filter(copy(s:command_list), 'v:val =~ "^" . a:arg_lead')
endfunction"}}}

function! octopress#execute(task, ...) "{{{
  if a:task =~# '^\(new_post\|new_page\|watch\|preview\|cd\)$'
    return octopress#command#{a:task}#execute(a:000)
  elseif a:task =~# '^\(generate\|deploy\|gen_deploy\|push\|rsync\|clean\|\)$'
    call octopress#system#execute(a:task)
  else
    call octopress#message#error("I don't know about that Octopress task.")
  endif
endfunction"}}}
