function! s:to_list(message) "{{{
  return type(a:message) ==# type([]) ? a:message : split(a:message, '\n')
endfunction"}}}

function! s:print_message(message, highlight_group) "{{{
  for mes in s:to_list(a:message)
    execute 'echohl' a:highlight_group
    echo mes
    echohl None
  endfor
endfunction"}}}

function! octopress#message#error(message) "{{{
  call s:print_message(a:message, 'WarningMsg')
endfunction"}}}

function! octopress#message#print(message) "{{{
  call s:print_message(a:message, 'Comment')
endfunction"}}}

function! octopress#message#clear() "{{{
  redraw
endfunction"}}}
